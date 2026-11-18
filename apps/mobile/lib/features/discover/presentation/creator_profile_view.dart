import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/links.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/discover/application/discover_providers.dart';
import 'package:talanta/features/discover/presentation/creator_tile.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/features/safety/report_sheet.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Someone else's profile, opened from a card.
class CreatorProfileScreen extends ConsumerWidget {
  const CreatorProfileScreen({required this.username, super.key});

  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(creatorProvider(username));
    return Scaffold(
      appBar: AppBar(
        title: Text('@$username'),
        actions: [
          if (profile.value case final p? when !p.isMe)
            IconButton(
              key: const ValueKey('report-creator'),
              tooltip: l10n.reportUser,
              icon: const Icon(Icons.flag_outlined),
              onPressed: () => showReportSheet(
                context,
                target: ReportTarget.user,
                targetId: p.id,
              ),
            ),
        ],
      ),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => TalantaErrorState(
          error: error,
          onRetry: () => ref.invalidate(creatorProvider(username)),
        ),
        data: (p) => CreatorProfileView(profile: p),
      ),
    );
  }
}

/// The profile body, shared by other people's profiles and my own tab.
class CreatorProfileView extends ConsumerStatefulWidget {
  const CreatorProfileView({
    required this.profile,
    super.key,
    this.header,
    this.onAddWork,
    this.onRemoveWork,
    this.footer,
  });

  final CreatorProfile profile;
  final Widget? header;
  final VoidCallback? onAddWork;
  final ValueChanged<PortfolioItem>? onRemoveWork;
  final Widget? footer;

  @override
  ConsumerState<CreatorProfileView> createState() => _CreatorProfileViewState();
}

class _CreatorProfileViewState extends ConsumerState<CreatorProfileView> {
  bool _busy = false;

  Future<void> _toggleFollow() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref
          .read(talantaActionsProvider)
          .follow(widget.profile.username, follow: !widget.profile.isFollowing);
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
    final p = widget.profile;
    final mine = p.isMe;

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(creatorProvider(p.username)),
      child: ListView(
        padding: const EdgeInsets.all(TalantaSpacing.x5),
        children: [
          ?widget.header,
          Row(
            children: [
              TalantaAvatar(
                name: p.displayName,
                size: 72,
                verified: p.isVerified,
              ),
              const SizedBox(width: TalantaSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.displayName, style: context.text.headlineSmall),
                    Text(
                      '@${p.username}${p.city == null ? '' : ' · ${p.city}'}',
                      style: context.text.bodyMedium?.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                    const SizedBox(height: TalantaSpacing.x1),
                    Text(
                      '${l10n.followersCount(p.followerCount.toInt())} · '
                      '${l10n.followingCount(p.followingCount.toInt())}',
                      key: const ValueKey('follow-counts'),
                      style: context.text.labelMedium?.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (p.bio case final bio? when bio.isNotEmpty) ...[
            const SizedBox(height: TalantaSpacing.x4),
            Text(bio, style: context.text.bodyLarge),
          ],
          const SizedBox(height: TalantaSpacing.x4),
          Wrap(
            spacing: TalantaSpacing.x2,
            runSpacing: TalantaSpacing.x2,
            children: [
              for (final t in p.talents)
                TalantaTag(
                  label: TalentNames.of(l10n, t.slug, t.name),
                  icon: TalentIcons.of(t.icon),
                  color: t.isPrimary ? TalantaBrand.primary : null,
                ),
              if (p.isVerified)
                TalantaTag(
                  label: l10n.verified,
                  icon: Icons.verified_rounded,
                  color: TalantaBrand.gold,
                ),
            ],
          ),
          if (!mine) ...[
            const SizedBox(height: TalantaSpacing.x5),
            TalantaButton(
              key: const ValueKey('follow-button'),
              label: p.isFollowing ? l10n.followingButton : l10n.follow,
              icon: p.isFollowing
                  ? Icons.check_rounded
                  : Icons.person_add_alt_1_rounded,
              variant: p.isFollowing
                  ? TalantaButtonVariant.secondary
                  : TalantaButtonVariant.primary,
              busy: _busy,
              onPressed: _toggleFollow,
            ),
          ],
          const SizedBox(height: TalantaSpacing.x6),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.portfolioTitle,
                  style: context.text.titleMedium,
                ),
              ),
              if (widget.onAddWork != null)
                TalantaButton(
                  key: const ValueKey('add-work'),
                  label: l10n.portfolioAdd,
                  icon: Icons.add_rounded,
                  variant: TalantaButtonVariant.ghost,
                  expand: false,
                  onPressed: widget.onAddWork,
                ),
            ],
          ),
          const SizedBox(height: TalantaSpacing.x2),
          if (p.portfolio.isEmpty)
            Text(
              mine ? l10n.portfolioEmptyMine : l10n.portfolioEmpty,
              style: context.text.bodyMedium?.copyWith(
                color: palette.textMuted,
              ),
            )
          else
            for (final piece in p.portfolio)
              Padding(
                padding: const EdgeInsets.only(bottom: TalantaSpacing.x2),
                child: PortfolioTile(
                  key: ValueKey('work-${piece.id}'),
                  title: piece.title,
                  platform: piece.platform,
                  onTap: () => unawaited(openExternalLink(context, piece.url)),
                  trailing: widget.onRemoveWork == null
                      ? null
                      : IconButton(
                          key: ValueKey('remove-${piece.id}'),
                          tooltip: l10n.remove,
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: palette.textMuted,
                          ),
                          onPressed: () => widget.onRemoveWork!(piece),
                        ),
                ),
              ),
          ?widget.footer,
        ],
      ),
    );
  }
}
