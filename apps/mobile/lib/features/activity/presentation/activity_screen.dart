import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/format/formatters.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/activity/application/activity_providers.dart';
import 'package:talanta/features/opportunities/application/opportunities_providers.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/features/opportunities/presentation/opportunity_detail_screen.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Notification text in the reader's language.
String notificationText(AppLocalizations l10n, ActivityItem n) {
  final name = n.actor?.displayName ?? l10n.someone;
  final title = n.opportunityTitle ?? '';
  return switch (n.type) {
    NotificationType.applicationReceived => l10n.notifApplicationReceived(
      name,
      title,
    ),
    NotificationType.newFollower => l10n.notifNewFollower(name),
    NotificationType.postLiked => l10n.notifPostLiked(name),
    NotificationType.postCommented => l10n.notifPostCommented(
      name,
      n.snippet ?? '',
    ),
    NotificationType.applicationStatus => switch (n.applicationStatus) {
      ApplicationStatus.shortlisted => l10n.notifShortlisted(title),
      ApplicationStatus.hired => l10n.notifHired(title),
      ApplicationStatus.declined => l10n.notifDeclined(title),
      _ => l10n.notifUpdate(title),
    },
    _ => l10n.notifUpdate(title),
  };
}

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  bool _applications = false;

  @override
  void initState() {
    super.initState();
    // Opening the tab counts as seeing everything in it.
    unawaited(
      Future<void>.microtask(() async {
        try {
          await ref.read(talantaActionsProvider).markAllRead();
        } on Object {
          // The badge simply stays until next time.
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      key: const ValueKey('activity-screen'),
      appBar: AppBar(title: Text(l10n.activityTitle)),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TalantaSpacing.x5,
              ),
              child: Wrap(
                spacing: TalantaSpacing.x2,
                runSpacing: TalantaSpacing.x2,
                children: [
                  TalantaChip(
                    key: const ValueKey('tab-notifications'),
                    label: l10n.activityNotifications,
                    selected: !_applications,
                    onTap: () => setState(() => _applications = false),
                  ),

                  TalantaChip(
                    key: const ValueKey('tab-applications'),
                    label: l10n.activityApplications,
                    selected: _applications,
                    onTap: () => setState(() => _applications = true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TalantaSpacing.x3),
            Expanded(
              child: _applications
                  ? const _MyApplications()
                  : const _Notifications(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Notifications extends ConsumerWidget {
  const _Notifications();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final page = ref.watch(notificationsProvider);
    return page.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => TalantaErrorState(
        error: error,
        onRetry: () => ref.invalidate(notificationsProvider),
      ),
      data: (data) => data.items.isEmpty
          ? TalantaEmptyState(
              icon: Icons.notifications_none_rounded,
              title: l10n.activityEmpty,
              body: l10n.activityEmptyBody,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(notificationsProvider),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  TalantaSpacing.x5,
                  0,
                  TalantaSpacing.x5,
                  TalantaSpacing.x8,
                ),
                itemCount: data.items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: TalantaSpacing.x2),
                itemBuilder: (_, index) {
                  final n = data.items[index];
                  final opportunityId = n.opportunityId;
                  final postId = n.postId;
                  final actor = n.actor;
                  return TalantaCard(
                    key: ValueKey('notification-${n.id}'),
                    raised: !n.isRead,
                    onTap: () {
                      if (postId != null) {
                        unawaited(context.push(Routes.post(postId)));
                      } else if (n.type ==
                              NotificationType.applicationReceived &&
                          opportunityId != null) {
                        unawaited(
                          context.push(Routes.applicants(opportunityId)),
                        );
                      } else if (opportunityId != null) {
                        unawaited(context.push(Routes.call(opportunityId)));
                      } else if (actor != null) {
                        unawaited(context.push(Routes.creator(actor.username)));
                      }
                    },
                    child: Row(
                      children: [
                        TalantaAvatar(
                          name: actor?.displayName ?? '?',
                          imageUrl: actor?.avatarUrl,
                          size: 40,
                        ),
                        const SizedBox(width: TalantaSpacing.x3),
                        Expanded(
                          child: Text(
                            notificationText(l10n, n),
                            style: context.text.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: TalantaSpacing.x2),
                        Text(
                          Formatters.ago(context, n.createdAt, clock.now()),
                          style: context.text.bodySmall?.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _MyApplications extends ConsumerWidget {
  const _MyApplications();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final mine = ref.watch(myApplicationsProvider);
    return mine.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => TalantaErrorState(
        error: error,
        onRetry: () => ref.invalidate(myApplicationsProvider),
      ),
      data: (list) => list.isEmpty
          ? TalantaEmptyState(
              icon: Icons.work_outline_rounded,
              title: l10n.applicationsEmpty,
              body: l10n.applicationsEmptyBody,
              actionLabel: l10n.browseCalls,
              onAction: () => context.go(Routes.calls),
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(myApplicationsProvider),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  TalantaSpacing.x5,
                  0,
                  TalantaSpacing.x5,
                  TalantaSpacing.x8,
                ),
                itemCount: list.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: TalantaSpacing.x2),
                itemBuilder: (_, index) {
                  final a = list[index];
                  final (label, color) = applicationStatusLook(
                    context,
                    a.status,
                  );
                  return TalantaCard(
                    key: ValueKey('application-${a.applicationId}'),
                    onTap: () =>
                        unawaited(context.push(Routes.call(a.opportunity.id))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.opportunity.title,
                                style: context.text.titleSmall,
                              ),
                              Text(
                                '${a.opportunity.city} · ${Formatters.ago(context, a.createdAt, clock.now())}',
                                style: context.text.bodySmall?.copyWith(
                                  color: palette.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TalantaTag(label: label, color: color),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
