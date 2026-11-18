import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/format/formatters.dart';
import 'package:talanta/core/links.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/discover/application/discover_providers.dart';
import 'package:talanta/features/discover/presentation/creator_tile.dart';
import 'package:talanta/features/onboarding/application/talent_categories_provider.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  CreatorSearch _query = const CreatorSearch();
  bool _following = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(
          () => _query = CreatorSearch(query: text, talent: _query.talent),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories =
        ref.watch(talentCategoriesProvider).value ?? const <TalentCategory>[];

    return Scaffold(
      key: const ValueKey('discover-screen'),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TalantaSpacing.x5,
                TalantaSpacing.x5,
                TalantaSpacing.x5,
                TalantaSpacing.x3,
              ),
              child: Text(
                l10n.discoverTitle,
                style: context.text.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TalantaSpacing.x5,
              ),
              child: Wrap(
                spacing: TalantaSpacing.x2,
                runSpacing: TalantaSpacing.x2,
                children: [
                  TalantaChip(
                    key: const ValueKey('tab-creators'),
                    label: l10n.discoverCreators,
                    selected: !_following,
                    onTap: () => setState(() => _following = false),
                  ),

                  TalantaChip(
                    key: const ValueKey('tab-following'),
                    label: l10n.discoverFollowing,
                    selected: _following,
                    onTap: () => setState(() => _following = true),
                  ),
                ],
              ),
            ),
            if (!_following) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  TalantaSpacing.x5,
                  TalantaSpacing.x3,
                  TalantaSpacing.x5,
                  0,
                ),
                child: TextField(
                  key: const ValueKey('discover-search'),
                  controller: _search,
                  onChanged: _onSearch,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.discoverSearchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
              ),
              SizedBox(
                height: 56,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TalantaSpacing.x5,
                    vertical: TalantaSpacing.x2,
                  ),
                  children: [
                    TalantaChip(
                      label: l10n.callsAll,
                      selected: _query.talent == null,
                      onTap: () => setState(
                        () => _query = CreatorSearch(query: _query.query),
                      ),
                    ),
                    for (final c in categories) ...[
                      const SizedBox(width: TalantaSpacing.x2),
                      TalantaChip(
                        key: ValueKey('discover-talent-${c.slug}'),
                        label: TalentNames.of(l10n, c.slug, c.name),
                        icon: TalentIcons.of(c.icon),
                        selected: _query.talent == c.slug,
                        onTap: () => setState(
                          () => _query = CreatorSearch(
                            query: _query.query,
                            talent: c.slug,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(child: _CreatorsList(search: _query)),
            ] else
              const Expanded(child: _FollowingFeed()),
          ],
        ),
      ),
    );
  }
}

class _CreatorsList extends ConsumerWidget {
  const _CreatorsList({required this.search});

  final CreatorSearch search;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final results = ref.watch(creatorSearchProvider(search));
    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => TalantaErrorState(
        error: error,
        onRetry: () => ref.invalidate(creatorSearchProvider(search)),
      ),
      data: (page) => page.items.isEmpty
          ? TalantaEmptyState(
              icon: Icons.person_search_rounded,
              title: l10n.discoverEmpty,
            )
          : RefreshIndicator(
              onRefresh: () async =>
                  ref.invalidate(creatorSearchProvider(search)),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  TalantaSpacing.x5,
                  TalantaSpacing.x2,
                  TalantaSpacing.x5,
                  TalantaSpacing.x8,
                ),
                itemCount: page.items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: TalantaSpacing.x3),
                itemBuilder: (_, index) {
                  final creator = page.items[index];
                  return CreatorTile(
                    creator: creator,
                    onTap: () => unawaited(
                      context.push(Routes.creator(creator.username)),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _FollowingFeed extends ConsumerWidget {
  const _FollowingFeed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final feed = ref.watch(followingFeedProvider);
    return feed.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => TalantaErrorState(
        error: error,
        onRetry: () => ref.invalidate(followingFeedProvider),
      ),
      data: (page) => page.items.isEmpty
          ? TalantaEmptyState(
              icon: Icons.favorite_border_rounded,
              title: l10n.followingEmpty,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(followingFeedProvider),
              child: ListView.separated(
                padding: const EdgeInsets.all(TalantaSpacing.x5),
                itemCount: page.items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: TalantaSpacing.x4),
                itemBuilder: (_, index) {
                  final work = page.items[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => unawaited(
                          context.push(Routes.creator(work.creator.username)),
                        ),
                        child: Row(
                          children: [
                            TalantaAvatar(
                              name: work.creator.displayName,
                              size: 32,
                              verified: work.creator.isVerified,
                            ),
                            const SizedBox(width: TalantaSpacing.x2),
                            Expanded(
                              child: Text(
                                work.creator.displayName,
                                style: context.text.titleSmall,
                              ),
                            ),
                            Text(
                              Formatters.ago(
                                context,
                                work.createdAt,
                                clock.now(),
                              ),
                              style: context.text.bodySmall?.copyWith(
                                color: palette.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: TalantaSpacing.x2),
                      PortfolioTile(
                        title: work.title,
                        platform: work.platform,
                        onTap: () =>
                            unawaited(openExternalLink(context, work.url)),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
