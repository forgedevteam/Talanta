import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/format/formatters.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/features/opportunities/application/opportunities_providers.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/features/opportunities/presentation/apply_sheet.dart';
import 'package:talanta/features/opportunities/presentation/opportunity_card.dart';
import 'package:talanta/features/safety/report_sheet.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// The label and colour for an application's status.
(String, Color) applicationStatusLook(
  BuildContext context,
  ApplicationStatus status,
) {
  final l10n = AppLocalizations.of(context);
  final palette = context.palette;
  return switch (status) {
    ApplicationStatus.shortlisted => (
      l10n.statusShortlisted,
      TalantaBrand.gold,
    ),
    ApplicationStatus.hired => (l10n.statusHired, palette.success),
    ApplicationStatus.declined => (l10n.statusDeclined, palette.danger),
    _ => (l10n.statusSubmitted, palette.textMuted),
  };
}

class OpportunityDetailScreen extends ConsumerWidget {
  const OpportunityDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(opportunityProvider(id));
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (detail.value case final o? when !o.isMine)
            IconButton(
              key: const ValueKey('report-call'),
              tooltip: l10n.callReport,
              icon: const Icon(Icons.flag_outlined),
              onPressed: () => showReportSheet(
                context,
                target: ReportTarget.opportunity,
                targetId: o.id,
              ),
            ),
        ],
      ),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => TalantaErrorState(
          error: error,
          onRetry: () => ref.invalidate(opportunityProvider(id)),
        ),
        data: (o) => _Body(opportunity: o),
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.opportunity});

  final OpportunityDetail opportunity;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  bool _busy = false;

  Future<void> _close() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.callCloseConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const ValueKey('confirm-close'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.callClose),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(talantaActionsProvider)
          .closeOpportunity(widget.opportunity.id);
    } on ApiFailure catch (failure) {
      if (mounted) {
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
    final o = widget.opportunity;
    final talent = TalentNames.of(l10n, o.category.slug, o.category.name);
    final isOpen = o.status == OpportunityStatus.open;
    final poster = o.poster;

    Widget footer;
    if (o.isMine) {
      footer = Column(
        children: [
          TalantaButton(
            key: const ValueKey('view-applicants'),
            label: l10n.callViewApplicants(o.applicationsCount.toInt()),
            onPressed: () => unawaited(context.push(Routes.applicants(o.id))),
          ),
          if (isOpen) ...[
            const SizedBox(height: TalantaSpacing.x2),
            TalantaButton(
              key: const ValueKey('close-call'),
              label: l10n.callClose,
              variant: TalantaButtonVariant.ghost,
              busy: _busy,
              onPressed: _close,
            ),
          ],
        ],
      );
    } else if (o.myApplication case final mine?) {
      final (label, color) = applicationStatusLook(context, mine.status);
      footer = TalantaCard(
        raised: true,
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.callYourApplication,
                style: context.text.titleSmall,
              ),
            ),
            TalantaTag(
              key: const ValueKey('my-status'),
              label: label,
              color: color,
            ),
          ],
        ),
      );
    } else if (isOpen) {
      footer = TalantaButton(
        key: const ValueKey('apply'),
        label: l10n.callApply,
        onPressed: () => unawaited(showApplySheet(context, o.id)),
      );
    } else {
      footer = Text(
        l10n.callIsClosed,
        textAlign: TextAlign.center,
        style: context.text.bodyMedium?.copyWith(color: palette.textMuted),
      );
    }

    return SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: TalantaSpacing.x5,
              ),
              children: [
                Wrap(
                  spacing: TalantaSpacing.x2,
                  runSpacing: TalantaSpacing.x2,
                  children: [
                    TalantaTag(
                      label: talent,
                      icon: TalentIcons.of(o.category.icon),
                      color: TalantaBrand.primary,
                    ),
                    if (o.isFeatured)
                      TalantaTag(
                        label: l10n.callsFeatured,
                        icon: Icons.star_rounded,
                        color: TalantaBrand.gold,
                        filled: true,
                      ),
                    if (!isOpen)
                      TalantaTag(
                        label: l10n.callsClosed,
                        color: palette.danger,
                      ),
                  ],
                ),
                const SizedBox(height: TalantaSpacing.x3),
                Text(o.title, style: context.text.headlineMedium),
                const SizedBox(height: TalantaSpacing.x4),
                _Fact(
                  icon: Icons.payments_rounded,
                  text: compensationLabel(
                    context,
                    o.compensation,
                    o.budgetAmount,
                    o.currency,
                  ),
                ),
                _Fact(icon: Icons.place_rounded, text: o.city),
                if (o.deadline != null)
                  _Fact(
                    icon: Icons.schedule_rounded,
                    text: l10n.callsCloses(
                      Formatters.calendarDate(context, o.deadline!),
                    ),
                  ),
                _Fact(
                  icon: Icons.groups_rounded,
                  text: l10n.callsApplicants(o.applicationsCount.toInt()),
                ),
                const SizedBox(height: TalantaSpacing.x5),
                Text(l10n.callAbout, style: context.text.titleMedium),
                const SizedBox(height: TalantaSpacing.x2),
                Text(o.description, style: context.text.bodyLarge),
                if (poster != null) ...[
                  const SizedBox(height: TalantaSpacing.x6),
                  Text(l10n.callPostedBy, style: context.text.titleMedium),
                  const SizedBox(height: TalantaSpacing.x2),
                  TalantaCard(
                    key: const ValueKey('poster'),
                    onTap: () => unawaited(
                      context.push(Routes.creator(poster.username)),
                    ),
                    child: Row(
                      children: [
                        TalantaAvatar(
                          name: poster.displayName,
                          verified: poster.isVerified,
                        ),
                        const SizedBox(width: TalantaSpacing.x3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                poster.displayName,
                                style: context.text.titleSmall,
                              ),
                              Text(
                                '@${poster.username}${poster.city == null ? '' : ' · ${poster.city}'}',
                                style: context.text.bodySmall?.copyWith(
                                  color: palette.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: palette.textMuted,
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: TalantaSpacing.x4),
                TalantaCard(
                  borderColor: TalantaBrand.gold.withValues(alpha: 0.4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: TalantaBrand.gold,
                      ),
                      const SizedBox(width: TalantaSpacing.x3),
                      Expanded(
                        child: Text(
                          l10n.callSafety,
                          style: context.text.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TalantaSpacing.x6),
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
            child: footer,
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TalantaSpacing.x2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.palette.textMuted),
          const SizedBox(width: TalantaSpacing.x3),
          Expanded(child: Text(text, style: context.text.bodyLarge)),
        ],
      ),
    );
  }
}
