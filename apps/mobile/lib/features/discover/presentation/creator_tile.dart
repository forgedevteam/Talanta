import 'package:flutter/material.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// A creator in the Discover list.
class CreatorTile extends StatelessWidget {
  const CreatorTile({required this.creator, required this.onTap, super.key});

  final CreatorCard creator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final talent = creator.primaryTalent;
    return TalantaCard(
      key: ValueKey('creator-${creator.username}'),
      onTap: onTap,
      child: Row(
        children: [
          TalantaAvatar(
            name: creator.displayName,
            imageUrl: creator.avatarUrl,
            size: 52,
            verified: creator.isVerified,
          ),
          const SizedBox(width: TalantaSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(creator.displayName, style: context.text.titleSmall),
                const SizedBox(height: 2),
                Text(
                  [
                    if (talent != null)
                      TalentNames.of(l10n, talent.slug, talent.name),
                    if (creator.city != null) creator.city!,
                  ].join(' · '),
                  style: context.text.bodySmall?.copyWith(
                    color: palette.textMuted,
                  ),
                ),
                const SizedBox(height: TalantaSpacing.x1),
                Text(
                  '${l10n.followersCount(creator.followerCount.toInt())} · '
                  '${l10n.worksCount(creator.portfolioCount.toInt())}',
                  style: context.text.labelSmall?.copyWith(
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (talent != null)
            Icon(TalentIcons.of(talent.icon), color: TalantaBrand.primary),
        ],
      ),
    );
  }
}

/// Icon for where a portfolio link lives.
IconData platformIcon(PortfolioPlatform platform) => switch (platform) {
  PortfolioPlatform.youtube => Icons.smart_display_rounded,
  PortfolioPlatform.tiktok => Icons.music_video_rounded,
  PortfolioPlatform.instagram => Icons.camera_alt_rounded,
  PortfolioPlatform.facebook => Icons.facebook_rounded,
  PortfolioPlatform.audiomack ||
  PortfolioPlatform.boomplay ||
  PortfolioPlatform.soundcloud ||
  PortfolioPlatform.spotify => Icons.graphic_eq_rounded,
  _ => Icons.link_rounded,
};

/// A piece of work: tap to open it where it lives.
class PortfolioTile extends StatelessWidget {
  const PortfolioTile({
    required this.title,
    required this.platform,
    required this.onTap,
    super.key,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final PortfolioPlatform platform;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TalantaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(TalantaSpacing.x3),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TalantaBrand.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(TalantaRadii.sm),
            ),
            child: Icon(platformIcon(platform), color: TalantaBrand.primary),
          ),
          const SizedBox(width: TalantaSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleSmall, maxLines: 2),
                Text(
                  subtitle ?? platform.json ?? '',
                  style: context.text.bodySmall?.copyWith(
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          trailing ??
              Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: palette.textMuted,
              ),
        ],
      ),
    );
  }
}
