import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/links.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/onboarding/application/talent_categories_provider.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/features/opportunities/application/opportunities_providers.dart';
import 'package:talanta/features/opportunities/presentation/opportunity_card.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Opens a sponsored card: an in-app screen for `talanta:` links, the
/// browser for everything else.
void openPromotion(BuildContext context, Promotion promotion) {
  if (promotion.url == 'talanta:post-call') {
    unawaited(context.push(Routes.postCall));
  } else {
    unawaited(openExternalLink(context, promotion.url));
  }
}

class OpportunitiesScreen extends ConsumerStatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  ConsumerState<OpportunitiesScreen> createState() =>
      _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends ConsumerState<OpportunitiesScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 600) {
        unawaited(ref.read(opportunitiesFeedProvider.notifier).loadMore());
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final feed = ref.watch(opportunitiesFeedProvider);
    final promotions =
        ref.watch(feedPromotionsProvider).value ?? const <Promotion>[];
    final categories =
        ref.watch(talentCategoriesProvider).value ?? const <TalentCategory>[];
    final notifier = ref.read(opportunitiesFeedProvider.notifier);

    void openCall(OpportunitySummary o) =>
        unawaited(context.push(Routes.call(o.id)));

    final listChildren = <Widget>[];
    for (final (index, o) in feed.items.indexed) {
      listChildren.add(
        OpportunityCard(opportunity: o, onTap: () => openCall(o)),
      );
      // One sponsored card after the third call, never more than one per screen.
      if (index == 2 && promotions.isNotEmpty) {
        listChildren.add(
          PromotionCard(
            promotion: promotions.first,
            onTap: () => openPromotion(context, promotions.first),
          ),
        );
      }
    }

    return Scaffold(
      key: const ValueKey('calls-screen'),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('post-call'),
        backgroundColor: TalantaBrand.primary,
        foregroundColor: palette.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.callsPost),
        onPressed: () => unawaited(context.push(Routes.postCall)),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: TalantaBrand.primary,
          onRefresh: () async {
            ref.invalidate(feedPromotionsProvider);
            await notifier.refresh();
          },
          child: CustomScrollView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  TalantaSpacing.x5,
                  TalantaSpacing.x5,
                  TalantaSpacing.x5,
                  TalantaSpacing.x2,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.callsTitle, style: context.text.headlineLarge),
                      const SizedBox(height: TalantaSpacing.x1),
                      Text(
                        l10n.callsSubtitle,
                        style: context.text.bodyMedium?.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 56,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: TalantaSpacing.x5,
                      vertical: TalantaSpacing.x2,
                    ),
                    children: [
                      TalantaChip(
                        key: const ValueKey('filter-all'),
                        label: l10n.callsAll,
                        selected: feed.category == null,
                        onTap: () => unawaited(notifier.setCategory(null)),
                      ),
                      for (final c in categories) ...[
                        const SizedBox(width: TalantaSpacing.x2),
                        TalantaChip(
                          key: ValueKey('filter-${c.slug}'),
                          label: TalentNames.of(l10n, c.slug, c.name),
                          icon: TalentIcons.of(c.icon),
                          selected: feed.category == c.slug,
                          onTap: () => unawaited(notifier.setCategory(c.slug)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (feed.loading && feed.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (feed.error != null && feed.isEmpty)
                SliverFillRemaining(
                  child: TalantaErrorState(
                    error: feed.error!,
                    onRetry: () => unawaited(notifier.refresh()),
                  ),
                )
              else if (feed.isEmpty)
                SliverFillRemaining(
                  child: TalantaEmptyState(
                    icon: Icons.campaign_outlined,
                    title: l10n.callsEmpty,
                    body: l10n.callsEmptyBody,
                    actionLabel: l10n.callsPost,
                    onAction: () => unawaited(context.push(Routes.postCall)),
                  ),
                )
              else ...[
                if (feed.featured.isNotEmpty) ...[
                  _SectionTitle(
                    title: l10n.callsFeatured,
                    icon: Icons.star_rounded,
                  ),
                  _CardList(
                    children: [
                      for (final o in feed.featured)
                        OpportunityCard(
                          opportunity: o,
                          onTap: () => openCall(o),
                        ),
                    ],
                  ),
                ],
                if (feed.items.isNotEmpty) ...[
                  _SectionTitle(title: l10n.callsLatest),
                  _CardList(children: listChildren),
                ],
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: TalantaSpacing.x4,
                      bottom: 96,
                    ),
                    child: feed.loadingMore
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.icon});

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        TalantaSpacing.x5,
        TalantaSpacing.x4,
        TalantaSpacing.x5,
        TalantaSpacing.x3,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: TalantaBrand.gold),
              const SizedBox(width: TalantaSpacing.x1),
            ],
            Text(title, style: context.text.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _CardList extends StatelessWidget {
  const _CardList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: TalantaSpacing.x5),
      sliver: SliverList.separated(
        itemCount: children.length,
        itemBuilder: (_, index) => children[index],
        separatorBuilder: (_, _) => const SizedBox(height: TalantaSpacing.x3),
      ),
    );
  }
}
