import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/app/talanta_app_bar.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/opportunities/application/opportunities_providers.dart';
import 'package:talanta/features/opportunities/presentation/opportunity_card.dart';
import 'package:talanta/features/posts/application/posts_providers.dart';
import 'package:talanta/features/posts/presentation/create_sheet.dart';
import 'package:talanta/features/posts/presentation/post_card.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// The home feed: what creators are sharing, and paid work in between.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  PostSource _source = forYouSource;

  bool _onScroll(ScrollNotification note) {
    if (note.metrics.extentAfter < 800) {
      unawaited(ref.read(postListProvider(_source).notifier).loadMore());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final list = ref.watch(postListProvider(_source));

    return Scaffold(
      key: const ValueKey('home-screen'),
      appBar: const TalantaAppBar(),
      body: RefreshIndicator(
        onRefresh: () => ref.read(postListProvider(_source).notifier).refresh(),
        child: NotificationListener<ScrollNotification>(
          onNotification: _onScroll,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _ComposePrompt()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    TalantaSpacing.x4,
                    TalantaSpacing.x2,
                    TalantaSpacing.x4,
                    TalantaSpacing.x3,
                  ),
                  child: Row(
                    children: [
                      TalantaChip(
                        key: const ValueKey('feed-tab-for-you'),
                        label: l10n.feedForYou,
                        selected: _source == forYouSource,
                        onTap: () => setState(() => _source = forYouSource),
                      ),
                      const SizedBox(width: TalantaSpacing.x2),
                      TalantaChip(
                        key: const ValueKey('feed-tab-following'),
                        label: l10n.feedFollowing,
                        selected: _source == followingSource,
                        onTap: () => setState(() => _source = followingSource),
                      ),
                    ],
                  ),
                ),
              ),
              ..._posts(context, list),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _posts(BuildContext context, PostListState list) {
    final l10n = AppLocalizations.of(context);
    if (list.loading && list.ids.isEmpty) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (list.error != null && list.ids.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: TalantaErrorState(
            error: list.error!,
            onRetry: () =>
                ref.read(postListProvider(_source).notifier).refresh(),
          ),
        ),
      ];
    }
    if (list.ids.isEmpty) {
      final following = _source == followingSource;
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: TalantaEmptyState(
            icon: following
                ? Icons.people_outline_rounded
                : Icons.auto_awesome_rounded,
            title: following ? l10n.feedFollowingEmpty : l10n.feedEmpty,
            body: following ? l10n.feedFollowingEmptyBody : l10n.feedEmptyBody,
            actionLabel: following ? l10n.feedFindCreators : l10n.feedPostFirst,
            onAction: following
                ? () => context.go(Routes.discover)
                : () => unawaited(showCreateSheet(context)),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: TalantaSpacing.x3),
        sliver: SliverList.builder(
          itemCount: list.ids.length + 1,
          itemBuilder: (context, index) {
            if (index == list.ids.length) {
              return Padding(
                padding: const EdgeInsets.all(TalantaSpacing.x6),
                child: Center(
                  child: list.loadingMore
                      ? const CircularProgressIndicator()
                      : list.hasMore
                      ? const SizedBox.shrink()
                      : Text(
                          l10n.feedEnd,
                          style: context.text.bodySmall?.copyWith(
                            color: context.palette.textMuted,
                          ),
                        ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: TalantaSpacing.x3),
              child: Column(
                children: [
                  PostCard(postId: list.ids[index]),
                  // Paid work, a few posts in: the reason to come back daily.
                  if (index == 2) const _CallsStrip(),
                ],
              ),
            );
          },
        ),
      ),
    ];
  }
}

/// "What's new, Nkeng?" with quick ways to post.
class _ComposePrompt extends ConsumerWidget {
  const _ComposePrompt();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final session = ref.watch(sessionProvider);
    final profile = session is SignedIn ? session.me.profile : null;
    final firstName = (profile?.displayName ?? '').split(' ').first;

    void compose(ComposeMode mode) =>
        unawaited(context.push('${Routes.compose}?mode=${mode.name}'));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TalantaSpacing.x3,
        TalantaSpacing.x1,
        TalantaSpacing.x3,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(TalantaSpacing.x3),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(TalantaRadii.xl),
          border: Border.all(color: palette.outline),
        ),
        child: Row(
          children: [
            TalantaAvatar(
              name: profile?.displayName ?? '',
              imageUrl: profile?.avatarUrl,
              size: 40,
            ),
            const SizedBox(width: TalantaSpacing.x3),
            Expanded(
              child: InkWell(
                key: const ValueKey('compose-prompt'),
                onTap: () => compose(ComposeMode.text),
                borderRadius: BorderRadius.circular(TalantaRadii.pill),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TalantaSpacing.x4,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: palette.surfaceRaised,
                    borderRadius: BorderRadius.circular(TalantaRadii.pill),
                  ),
                  child: Text(
                    l10n.feedComposePrompt(firstName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyMedium?.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              key: const ValueKey('compose-photo'),
              tooltip: l10n.createPhoto,
              onPressed: () => compose(ComposeMode.photo),
              icon: const Icon(
                Icons.photo_library_outlined,
                color: TalantaBrand.primary,
              ),
            ),
            IconButton(
              tooltip: l10n.createReel,
              onPressed: () => compose(ComposeMode.reel),
              icon: const Icon(
                Icons.smart_display_outlined,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A row of open paid calls, between posts.
class _CallsStrip extends ConsumerWidget {
  const _CallsStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final feed = ref.watch(opportunitiesFeedProvider);
    final calls = [
      ...feed.featured,
      ...feed.items,
    ].where((call) => call.status == OpportunityStatus.open).take(6).toList();
    if (calls.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: TalantaSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TalantaSpacing.x1),
            child: Row(
              children: [
                const Icon(
                  Icons.payments_rounded,
                  color: TalantaBrand.gold,
                  size: 20,
                ),
                const SizedBox(width: TalantaSpacing.x2),
                Expanded(
                  child: Text(
                    l10n.feedPaidWork,
                    style: context.text.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(Routes.calls),
                  child: Text(l10n.feedSeeAll),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: calls.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: TalantaSpacing.x3),
              itemBuilder: (context, index) {
                final call = calls[index];
                return SizedBox(
                  width: 236,
                  child: Material(
                    color: palette.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TalantaRadii.lg),
                      side: BorderSide(
                        color: call.isFeatured
                            ? TalantaBrand.gold.withValues(alpha: 0.5)
                            : palette.outline,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(TalantaRadii.lg),
                      onTap: () =>
                          unawaited(context.push(Routes.call(call.id))),
                      child: Padding(
                        padding: const EdgeInsets.all(TalantaSpacing.x3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              call.city,
                              style: context.text.labelSmall?.copyWith(
                                color: palette.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              call.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.titleSmall,
                            ),
                            const Spacer(),
                            Text(
                              compensationLabel(
                                context,
                                call.compensation,
                                call.budgetAmount,
                                call.currency,
                              ),
                              style: context.text.labelLarge?.copyWith(
                                color: TalantaBrand.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
