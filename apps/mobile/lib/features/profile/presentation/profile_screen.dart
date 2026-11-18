import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/format/formatters.dart';
import 'package:talanta/core/links.dart';
import 'package:talanta/core/media/media.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/kente_strip.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/discover/application/discover_providers.dart';
import 'package:talanta/features/discover/presentation/creator_tile.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/features/posts/application/post_actions.dart';
import 'package:talanta/features/posts/application/posts_providers.dart';
import 'package:talanta/features/posts/presentation/create_sheet.dart';
import 'package:talanta/features/profile/presentation/add_work_sheet.dart';
import 'package:talanta/features/safety/report_sheet.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// My profile, reached from my picture at the top left of every tab.
class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final username = session is SignedIn ? session.me.profile?.username : null;
    if (username == null) return const Scaffold();
    return ProfileScreen(key: const ValueKey('me-screen'), username: username);
  }
}

enum _ProfileTab { posts, reels, work }

/// Anyone's profile: who they are, what they post, and their work.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({required this.username, super.key});

  final String username;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  _ProfileTab _tab = _ProfileTab.posts;

  PostSource get _source =>
      creatorSource(widget.username, reels: _tab == _ProfileTab.reels);

  Future<void> _refresh() async {
    ref
      ..invalidate(creatorProvider(widget.username))
      ..invalidate(postListProvider(creatorSource(widget.username)))
      ..invalidate(
        postListProvider(creatorSource(widget.username, reels: true)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(creatorProvider(widget.username));
    return Scaffold(
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => SafeArea(
          child: TalantaErrorState(
            error: error,
            onRetry: () => ref.invalidate(creatorProvider(widget.username)),
          ),
        ),
        data: (p) => RefreshIndicator(
          onRefresh: _refresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (note) {
              if (_tab != _ProfileTab.work && note.metrics.extentAfter < 600) {
                unawaited(
                  ref.read(postListProvider(_source).notifier).loadMore(),
                );
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _Header(profile: p)),
                SliverToBoxAdapter(
                  child: _Tabs(
                    current: _tab,
                    onChanged: (tab) => setState(() => _tab = tab),
                  ),
                ),
                if (_tab == _ProfileTab.work)
                  _WorkSliver(profile: p)
                else
                  _PostGrid(
                    source: _source,
                    mine: p.isMe,
                    reels: _tab == _ProfileTab.reels,
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: TalantaSpacing.x10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerStatefulWidget {
  const _Header({required this.profile});

  final CreatorProfile profile;

  @override
  ConsumerState<_Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<_Header> {
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

  Future<void> _shareProfile() async {
    final p = widget.profile;
    await ref.read(shareLauncherProvider)(
      '${p.displayName} (@${p.username}) on Talanta\nhttps://talanta.app/@${p.username}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final p = widget.profile;
    final canPop = context.canPop();
    final talent = p.primaryTalent;
    final subtitle = [
      '@${p.username}',
      if (talent != null) TalentNames.of(l10n, talent.slug, talent.name),
      if (p.city != null && p.city!.isNotEmpty) p.city!,
    ].join(' · ');

    const coverHeight = 130.0;
    const avatarSize = 92.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: coverHeight + avatarSize / 2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: coverHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.6, -0.8),
                      radius: 1.4,
                      colors: [
                        TalantaBrand.secondary.withValues(alpha: 0.75),
                        const Color(0xFF2A1745),
                        palette.background,
                      ],
                      stops: const [0, 0.55, 1],
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: coverHeight - 5,
                child: KenteStrip(height: 5),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      if (canPop)
                        _GlassButton(
                          icon: Icons.arrow_back_rounded,
                          label: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                          onTap: () => context.pop(),
                        ),
                      const Spacer(),
                      _GlassButton(
                        icon: Icons.ios_share_rounded,
                        label: l10n.profileShare,
                        onTap: _shareProfile,
                      ),
                      if (p.isMe)
                        _GlassButton(
                          key: const ValueKey('open-settings'),
                          icon: Icons.settings_outlined,
                          label: l10n.settingsTitle,
                          onTap: () => unawaited(context.push(Routes.settings)),
                        )
                      else
                        _GlassButton(
                          key: const ValueKey('report-creator'),
                          icon: Icons.flag_outlined,
                          label: l10n.reportUser,
                          onTap: () => unawaited(
                            showReportSheet(
                              context,
                              target: ReportTarget.user,
                              targetId: p.id,
                            ),
                          ),
                        ),
                      const SizedBox(width: TalantaSpacing.x2),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: TalantaSpacing.x4,
                top: coverHeight - avatarSize / 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: palette.background,
                  ),
                  child: TalantaAvatar(
                    name: p.displayName,
                    imageUrl: p.avatarUrl,
                    size: avatarSize - 8,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            TalantaSpacing.x4,
            TalantaSpacing.x3,
            TalantaSpacing.x4,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      p.displayName,
                      style: context.text.headlineMedium,
                    ),
                  ),
                  if (p.isVerified) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      color: TalantaBrand.gold,
                      size: 22,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: context.text.bodyMedium?.copyWith(
                  color: palette.textMuted,
                ),
              ),
              if (p.bio case final bio? when bio.isNotEmpty) ...[
                const SizedBox(height: TalantaSpacing.x3),
                Text(bio, style: context.text.bodyMedium),
              ],
              const SizedBox(height: TalantaSpacing.x4),
              Row(
                key: const ValueKey('follow-counts'),
                children: [
                  _Stat(value: p.postCount, label: l10n.profileStatPosts),
                  _Stat(
                    value: p.followerCount,
                    label: l10n.profileStatFollowers,
                  ),
                  _Stat(
                    value: p.followingCount,
                    label: l10n.profileStatFollowing,
                  ),
                  _Stat(value: p.portfolio.length, label: l10n.profileStatWork),
                ],
              ),
              const SizedBox(height: TalantaSpacing.x4),
              if (p.isMe)
                Row(
                  children: [
                    Expanded(
                      child: TalantaButton(
                        key: const ValueKey('edit-profile'),
                        label: l10n.profileMenuEdit,
                        icon: Icons.edit_outlined,
                        onPressed: () =>
                            unawaited(context.push(Routes.editProfile)),
                      ),
                    ),
                    const SizedBox(width: TalantaSpacing.x2),
                    Expanded(
                      child: TalantaButton(
                        key: const ValueKey('profile-new-post'),
                        label: l10n.profileNewPost,
                        icon: Icons.add_rounded,
                        variant: TalantaButtonVariant.secondary,
                        onPressed: () => unawaited(showCreateSheet(context)),
                      ),
                    ),
                  ],
                )
              else
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
              if (p.talents.isNotEmpty) ...[
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
                  ],
                ),
              ],
              const SizedBox(height: TalantaSpacing.x4),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TalantaSpacing.x1),
      child: IconButton(
        tooltip: label,
        onPressed: onTap,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0x66000000),
          foregroundColor: Colors.white,
        ),
        icon: Icon(icon, size: 21),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final num value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            Formatters.compact(context, value),
            style: context.text.titleLarge,
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodySmall?.copyWith(
              color: context.palette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.current, required this.onChanged});

  final _ProfileTab current;
  final ValueChanged<_ProfileTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    Widget tab(_ProfileTab value, IconData icon, String label) {
      final active = value == current;
      return Expanded(
        child: InkWell(
          key: ValueKey('profile-tab-${value.name}'),
          onTap: () => onChanged(value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: TalantaSpacing.x3),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: active ? TalantaBrand.primary : palette.outline,
                  width: active ? 2.5 : 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: active ? palette.text : palette.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: context.text.labelMedium?.copyWith(
                    color: active ? palette.text : palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab(_ProfileTab.posts, Icons.grid_on_rounded, l10n.profileTabPosts),
        tab(_ProfileTab.reels, Icons.smart_display_outlined, l10n.navReels),
        tab(_ProfileTab.work, Icons.work_outline_rounded, l10n.profileTabWork),
      ],
    );
  }
}

/// Posts as a grid of squares (reels as tall tiles). Tap opens the post.
class _PostGrid extends ConsumerWidget {
  const _PostGrid({
    required this.source,
    required this.mine,
    required this.reels,
  });

  final PostSource source;
  final bool mine;
  final bool reels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final list = ref.watch(postListProvider(source));
    if (list.loading && list.ids.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(TalantaSpacing.x8),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (list.ids.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TalantaSpacing.x4),
          child: TalantaEmptyState(
            icon: reels ? Icons.smart_display_outlined : Icons.photo_outlined,
            title: mine
                ? (reels ? l10n.reelsEmptyTitle : l10n.profileNoPostsMine)
                : l10n.profileNoPosts,
            body: mine ? l10n.profileNoPostsMineBody : null,
            actionLabel: mine ? l10n.profileNewPost : null,
            onAction: mine ? () => unawaited(showCreateSheet(context)) : null,
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.only(top: 2),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: reels ? 9 / 16 : 1,
        ),
        itemCount: list.ids.length,
        itemBuilder: (context, index) => _GridTile(postId: list.ids[index]),
      ),
    );
  }
}

class _GridTile extends ConsumerWidget {
  const _GridTile({required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postId));
    if (post == null) return const SizedBox.shrink();
    final palette = context.palette;
    final image = ref.watch(networkImageProvider);

    Widget content;
    switch (post.kind) {
      case PostKind.photo when post.media.isNotEmpty:
        content = Image(
          image: image(post.media.first.url),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => ColoredBox(color: palette.surfaceRaised),
        );
      case PostKind.video:
        content = DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TalantaBrand.secondary.withValues(alpha: 0.6),
                const Color(0xFF1A0F2A),
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
        );
      case PostKind.text || PostKind.photo || PostKind.$unknown:
        content = Container(
          color: palette.surfaceRaised,
          padding: const EdgeInsets.all(TalantaSpacing.x2),
          alignment: Alignment.center,
          child: Text(
            post.body ?? '',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.text.bodySmall,
          ),
        );
    }

    return GestureDetector(
      key: ValueKey('grid-${post.id}'),
      onTap: () => unawaited(context.push(Routes.post(post.id))),
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          if (post.media.length > 1)
            const Positioned(
              top: 6,
              right: 6,
              child: Icon(
                Icons.collections_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          if (post.likeCount > 0)
            Positioned(
              left: 6,
              bottom: 4,
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 13,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    Formatters.compact(context, post.likeCount),
                    style: context.text.labelSmall?.copyWith(
                      color: Colors.white,
                      shadows: const [
                        Shadow(blurRadius: 6, color: Colors.black54),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Links to work on other platforms. Mine can be added and removed here.
class _WorkSliver extends ConsumerWidget {
  const _WorkSliver({required this.profile});

  final CreatorProfile profile;

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    PortfolioItem piece,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        content: Text(l10n.portfolioRemoveConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const ValueKey('confirm-remove'),
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(talantaActionsProvider).removePortfolioItem(piece.id);
    } on ApiFailure catch (failure) {
      if (context.mounted) {
        TalantaSnack.show(context, failure.message(l10n), error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final mine = profile.isMe;
    return SliverPadding(
      padding: const EdgeInsets.all(TalantaSpacing.x4),
      sliver: SliverList.list(
        children: [
          Text(
            mine ? l10n.portfolioIntroMine : l10n.portfolioIntro,
            style: context.text.bodyMedium?.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: TalantaSpacing.x3),
          if (mine)
            Padding(
              padding: const EdgeInsets.only(bottom: TalantaSpacing.x3),
              child: TalantaButton(
                key: const ValueKey('add-work'),
                label: l10n.portfolioAdd,
                icon: Icons.add_link_rounded,
                variant: TalantaButtonVariant.secondary,
                onPressed: () => unawaited(showAddWorkSheet(context)),
              ),
            ),
          if (profile.portfolio.isEmpty)
            Text(
              mine ? l10n.portfolioEmptyMine : l10n.portfolioEmpty,
              style: context.text.bodyMedium?.copyWith(
                color: palette.textMuted,
              ),
            )
          else
            for (final piece in profile.portfolio)
              Padding(
                padding: const EdgeInsets.only(bottom: TalantaSpacing.x2),
                child: PortfolioTile(
                  key: ValueKey('work-${piece.id}'),
                  title: piece.title,
                  platform: piece.platform,
                  onTap: () => unawaited(openExternalLink(context, piece.url)),
                  trailing: mine
                      ? IconButton(
                          key: ValueKey('remove-${piece.id}'),
                          tooltip: l10n.remove,
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: palette.textMuted,
                          ),
                          onPressed: () =>
                              unawaited(_remove(context, ref, piece)),
                        )
                      : null,
                ),
              ),
        ],
      ),
    );
  }
}
