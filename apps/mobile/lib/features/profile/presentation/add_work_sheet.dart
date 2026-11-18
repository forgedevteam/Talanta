import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/onboarding/application/talent_categories_provider.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

Future<void> showAddWorkSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: const _AddWorkSheet(),
    ),
  );
}

class _AddWorkSheet extends ConsumerStatefulWidget {
  const _AddWorkSheet();

  @override
  ConsumerState<_AddWorkSheet> createState() => _AddWorkSheetState();
}

class _AddWorkSheetState extends ConsumerState<_AddWorkSheet> {
  final _title = TextEditingController();
  final _link = TextEditingController();
  String? _categoryId;
  String? _titleError;
  String? _linkError;
  bool _busy = false;

  @override
  void dispose() {
    _title.dispose();
    _link.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final title = _title.text.trim();
    final link = _link.text.trim();
    setState(() {
      _titleError = title.length < 2 ? l10n.portfolioErrorTitle : null;
      _linkError = link.startsWith('https://')
          ? null
          : l10n.errorLinkNotAllowed;
    });
    if (_titleError != null || _linkError != null) return;

    final navigator = Navigator.of(context);
    setState(() => _busy = true);
    try {
      await ref
          .read(talantaActionsProvider)
          .addPortfolioItem(
            CreatePortfolioItem(
              title: title,
              url: link,
              categoryId: _categoryId,
            ),
          );
      if (!mounted) return;
      navigator.pop();
      TalantaSnack.show(context, l10n.portfolioAdded);
    } on ApiFailure catch (failure) {
      if (!mounted) return;
      final fieldError = failure is ProblemFailure
          ? failure.fieldMessage('url')
          : null;
      if (fieldError != null ||
          (failure is ProblemFailure &&
              failure.code == ErrorCode.linkNotAllowed)) {
        setState(() => _linkError = failure.message(l10n));
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          TalantaSpacing.x5,
          TalantaSpacing.x2,
          TalantaSpacing.x5,
          TalantaSpacing.x4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.portfolioAdd, style: context.text.headlineSmall),
            const SizedBox(height: TalantaSpacing.x4),
            TalantaTextField(
              key: const ValueKey('work-title'),
              label: l10n.portfolioTitleLabel,
              hint: l10n.portfolioTitleHint,
              controller: _title,
              error: _titleError,
              maxLength: 80,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: TalantaSpacing.x4),
            TalantaTextField(
              key: const ValueKey('work-link'),
              label: l10n.portfolioLinkLabel,
              hint: 'https://',
              helper: l10n.portfolioLinkHelp,
              controller: _link,
              error: _linkError,
              keyboardType: TextInputType.url,
              maxLength: 500,
            ),
            const SizedBox(height: TalantaSpacing.x4),
            Text(
              l10n.portfolioTalentLabel,
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
                    label: TalentNames.of(l10n, c.slug, c.name),
                    icon: TalentIcons.of(c.icon),
                    selected: _categoryId == c.id,
                    onTap: () => setState(
                      () => _categoryId = _categoryId == c.id ? null : c.id,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TalantaSpacing.x5),
            TalantaButton(
              key: const ValueKey('save-work'),
              label: l10n.portfolioSave,
              busy: _busy,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
