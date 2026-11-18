import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/links.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/features/opportunities/application/opportunities_providers.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/features/opportunities/presentation/opportunity_detail_screen.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

class ApplicantsScreen extends ConsumerWidget {
  const ApplicantsScreen({required this.opportunityId, super.key});

  final String opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final applicants = ref.watch(applicantsProvider(opportunityId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.applicantsTitle)),
      body: applicants.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => TalantaErrorState(
          error: error,
          onRetry: () => ref.invalidate(applicantsProvider(opportunityId)),
        ),
        data: (list) => list.isEmpty
            ? TalantaEmptyState(
                icon: Icons.inbox_outlined,
                title: l10n.applicantsEmpty,
                body: l10n.applicantsEmptyBody,
              )
            : RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(applicantsProvider(opportunityId)),
                child: ListView.separated(
                  padding: const EdgeInsets.all(TalantaSpacing.x5),
                  itemCount: list.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: TalantaSpacing.x3),
                  itemBuilder: (_, index) => _ApplicantCard(
                    opportunityId: opportunityId,
                    applicant: list[index],
                  ),
                ),
              ),
      ),
    );
  }
}

class _ApplicantCard extends ConsumerStatefulWidget {
  const _ApplicantCard({required this.opportunityId, required this.applicant});

  final String opportunityId;
  final Applicant applicant;

  @override
  ConsumerState<_ApplicantCard> createState() => _ApplicantCardState();
}

class _ApplicantCardState extends ConsumerState<_ApplicantCard> {
  bool _busy = false;

  Future<void> _decide(ApplicationDecision decision) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref
          .read(talantaActionsProvider)
          .decide(
            widget.opportunityId,
            widget.applicant.applicationId,
            decision,
          );
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
    final a = widget.applicant;
    final person = a.applicant;
    final (statusLabel, statusColor) = applicationStatusLook(context, a.status);
    final talent = person.primaryTalent;

    return TalantaCard(
      key: ValueKey('applicant-${a.applicationId}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () =>
                unawaited(context.push(Routes.creator(person.username))),
            child: Row(
              children: [
                TalantaAvatar(
                  name: person.displayName,
                  verified: person.isVerified,
                ),
                const SizedBox(width: TalantaSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(person.displayName, style: context.text.titleSmall),
                      Text(
                        [
                          if (talent != null)
                            TalentNames.of(l10n, talent.slug, talent.name),
                          if (person.city != null) person.city!,
                        ].join(' · '),
                        style: context.text.bodySmall?.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                TalantaTag(label: statusLabel, color: statusColor),
              ],
            ),
          ),
          const SizedBox(height: TalantaSpacing.x3),
          Text(a.message, style: context.text.bodyMedium),
          if (a.portfolioItem case final piece?) ...[
            const SizedBox(height: TalantaSpacing.x3),
            TalantaCard(
              raised: true,
              padding: const EdgeInsets.all(TalantaSpacing.x3),
              onTap: () => unawaited(openExternalLink(context, piece.url)),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    color: TalantaBrand.primary,
                  ),
                  const SizedBox(width: TalantaSpacing.x2),
                  Expanded(
                    child: Text(piece.title, style: context.text.labelLarge),
                  ),
                  Text(
                    l10n.viewWork,
                    style: context.text.labelMedium?.copyWith(
                      color: TalantaBrand.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: TalantaSpacing.x3),
          Wrap(
            spacing: TalantaSpacing.x2,
            runSpacing: TalantaSpacing.x2,
            children: [
              if (a.status != ApplicationStatus.shortlisted)
                TalantaButton(
                  key: ValueKey('shortlist-${a.applicationId}'),
                  label: l10n.actionShortlist,
                  variant: TalantaButtonVariant.secondary,
                  expand: false,
                  busy: _busy,
                  onPressed: () => _decide(ApplicationDecision.shortlisted),
                ),
              if (a.status != ApplicationStatus.hired)
                TalantaButton(
                  key: ValueKey('hire-${a.applicationId}'),
                  label: l10n.actionHire,
                  expand: false,
                  busy: _busy,
                  onPressed: () => _decide(ApplicationDecision.hired),
                ),
              if (a.status != ApplicationStatus.declined)
                TalantaButton(
                  key: ValueKey('decline-${a.applicationId}'),
                  label: l10n.actionDecline,
                  variant: TalantaButtonVariant.ghost,
                  expand: false,
                  busy: _busy,
                  onPressed: () => _decide(ApplicationDecision.declined),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
