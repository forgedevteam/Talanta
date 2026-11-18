import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/onboarding/application/onboarding_controller.dart';
import 'package:talanta/features/onboarding/application/talent_categories_provider.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

class PostOpportunityScreen extends ConsumerStatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  ConsumerState<PostOpportunityScreen> createState() =>
      _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends ConsumerState<PostOpportunityScreen> {
  final _title = TextEditingController();
  final _city = TextEditingController();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  String? _categoryId;
  CompensationType _pay = CompensationType.paid;
  DateTime? _deadline;
  bool _busy = false;
  final Map<String, String?> _errors = {};

  @override
  void initState() {
    super.initState();
    final session = ref.read(sessionProvider);
    if (session is SignedIn) _city.text = session.me.profile?.city ?? '';
  }

  @override
  void dispose() {
    _title.dispose();
    _city.dispose();
    _description.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final today = clock.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? today.add(const Duration(days: 14)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null && mounted) setState(() => _deadline = picked);
  }

  bool _validate(AppLocalizations l10n) {
    final title = _title.text.trim();
    final description = _description.text.trim();
    final amount = int.tryParse(_amount.text.replaceAll(RegExp(r'\D'), ''));
    setState(() {
      _errors
        ..clear()
        ..['title'] = title.length < 5 || title.length > 100
            ? l10n.postErrorTitle
            : null
        ..['categoryId'] = _categoryId == null ? l10n.postErrorTalent : null
        ..['city'] = _city.text.trim().length < 2 ? l10n.profileErrorCity : null
        ..['description'] = description.length < 20
            ? l10n.postErrorDescription
            : null
        ..['budgetAmount'] =
            _pay == CompensationType.paid && (amount == null || amount < 500)
            ? l10n.postErrorAmount
            : null;
    });
    return _errors.values.every((error) => error == null);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!_validate(l10n)) return;
    setState(() => _busy = true);
    final amount = int.tryParse(_amount.text.replaceAll(RegExp(r'\D'), ''));
    try {
      final created = await ref
          .read(talantaActionsProvider)
          .postOpportunity(
            CreateOpportunity(
              title: _title.text.trim(),
              description: _description.text.trim(),
              categoryId: _categoryId!,
              city: _city.text.trim(),
              compensation: _pay,
              budgetAmount: _pay == CompensationType.unpaid ? null : amount,
              deadline: _deadline == null ? null : isoDate(_deadline!),
            ),
          );
      if (!mounted) return;
      TalantaSnack.show(context, l10n.postPublished);
      context.pushReplacement(Routes.call(created.id));
    } on ApiFailure catch (failure) {
      if (!mounted) return;
      if (failure is ProblemFailure && failure.problem.fields != null) {
        setState(() {
          for (final field in [
            'title',
            'description',
            'city',
            'budgetAmount',
            'deadline',
          ]) {
            _errors[field] = failure.fieldMessage(field);
          }
        });
      } else {
        TalantaSnack.show(context, failure.message(l10n), error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final categories =
        ref.watch(talentCategoriesProvider).value ?? const <TalentCategory>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.postTitle)),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(TalantaSpacing.x5),
                children: [
                  Text(
                    l10n.postSubtitle,
                    style: context.text.bodyMedium?.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: TalantaSpacing.x5),
                  TalantaTextField(
                    key: const ValueKey('post-title'),
                    label: l10n.postTitleLabel,
                    hint: l10n.postTitleHint,
                    controller: _title,
                    error: _errors['title'],
                    maxLength: 100,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: TalantaSpacing.x4),
                  Text(
                    l10n.postTalentLabel,
                    style: context.text.labelMedium?.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: TalantaSpacing.x2),
                  Wrap(
                    spacing: TalantaSpacing.x2,
                    runSpacing: TalantaSpacing.x2,
                    children: [
                      for (final c in categories)
                        TalantaChip(
                          key: ValueKey('post-talent-${c.slug}'),
                          label: TalentNames.of(l10n, c.slug, c.name),
                          icon: TalentIcons.of(c.icon),
                          selected: _categoryId == c.id,
                          onTap: () => setState(() {
                            _categoryId = c.id;
                            _errors['categoryId'] = null;
                          }),
                        ),
                    ],
                  ),
                  if (_errors['categoryId'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: TalantaSpacing.x2),
                      child: Text(
                        _errors['categoryId']!,
                        style: context.text.bodySmall?.copyWith(
                          color: palette.danger,
                        ),
                      ),
                    ),
                  const SizedBox(height: TalantaSpacing.x4),
                  TalantaTextField(
                    key: const ValueKey('post-city'),
                    label: l10n.postCityLabel,
                    controller: _city,
                    error: _errors['city'],
                    maxLength: 80,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: TalantaSpacing.x4),
                  TalantaTextField(
                    key: const ValueKey('post-description'),
                    label: l10n.postDescriptionLabel,
                    hint: l10n.postDescriptionHint,
                    controller: _description,
                    error: _errors['description'],
                    maxLength: 2000,
                    minLines: 4,
                    maxLines: 10,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: TalantaSpacing.x4),
                  Text(
                    l10n.postPayLabel,
                    style: context.text.labelMedium?.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: TalantaSpacing.x2),
                  Wrap(
                    spacing: TalantaSpacing.x2,
                    children: [
                      for (final (type, label) in [
                        (CompensationType.paid, l10n.postPaid),
                        (CompensationType.negotiable, l10n.postNegotiable),
                        (CompensationType.unpaid, l10n.postUnpaid),
                      ])
                        TalantaChip(
                          key: ValueKey('pay-${type.name}'),
                          label: label,
                          selected: _pay == type,
                          onTap: () => setState(() => _pay = type),
                        ),
                    ],
                  ),
                  if (_pay != CompensationType.unpaid) ...[
                    const SizedBox(height: TalantaSpacing.x4),
                    TalantaTextField(
                      key: const ValueKey('post-amount'),
                      label: l10n.postAmountLabel,
                      hint: '150000',
                      controller: _amount,
                      error: _errors['budgetAmount'],
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 9,
                    ),
                  ],
                  const SizedBox(height: TalantaSpacing.x4),
                  TalantaDateField(
                    key: const ValueKey('post-deadline'),
                    label: l10n.postDeadlineLabel,
                    value: _deadline,
                    hint: l10n.postDeadlineHint,
                    error: _errors['deadline'],
                    onTap: _busy ? null : _pickDeadline,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TalantaSpacing.x5,
                TalantaSpacing.x2,
                TalantaSpacing.x5,
                TalantaSpacing.x4,
              ),
              child: TalantaButton(
                key: const ValueKey('publish-call'),
                label: l10n.postSubmit,
                busy: _busy,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
