import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/format/formatters.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/posts/application/post_actions.dart';
import 'package:talanta/features/posts/application/posts_providers.dart';
import 'package:talanta/features/posts/presentation/create_sheet.dart';
import 'package:talanta/features/posts/presentation/post_card.dart';
import 'package:talanta/features/posts/presentation/post_video.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Short videos, one screen each. Swipe up for the next.
class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final list = ref.watch(postListProvider(reelsSource));
    // Off screen (another tab, or a page on top): nothing plays.
    final visible = TickerMode.valuesOf(context).enabled;

    Widget body;
    if (list.loading && list.ids.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (list.error != null && list.ids.isEmpty) {
      body = TalantaErrorState(
        error: list.error!,
        onRetry: () =>
            ref.read(postListProvider(reelsSource).notifier).refresh(),
      );
    } else if (list.ids.isEmpty) {
      body = _EmptyReels(
        onPost: () => unawaited(
          context.push('${Routes.compose}?mode=${ComposeMode.reel.name}'),
        ),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: () =>
            ref.read(postListProvider(reelsSource).notifier).refresh(),
        child: PageView.builder(
          key: const ValueKey('reels-pager'),
          scrollDirection: Axis.vertical,
          itemCount: list.ids.length,
          onPageChanged: (page) {
            setState(() => _page = page);
            if (page >= list.ids.length - 3) {
              unawaited(
                ref.read(postListProvider(reelsSource).notifier).loadMore(),
              );
            }
          },
          itemBuilder: (context, index) => _ReelPage(
            postId: list.ids[index],
            active: visible && index == _page,
          ),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: const ValueKey('reels-screen'),
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(child: body),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _ReelsTopBar(title: l10n.navReels),
            ),
          ],
        ),
      ),
    );
  }
}

/// My picture on the left, the title, and settings on the right, over the video.
class _ReelsTopBar extends ConsumerWidget {
  const _ReelsTopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    final profile = session is SignedIn ? session.me.profile : null;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x99000000), Color(0x00000000)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            TalantaSpacing.x4,
            TalantaSpacing.x2,
            TalantaSpacing.x2,
            TalantaSpacing.x4,
          ),
          child: Row(
            children: [
              GestureDetector(
                key: const ValueKey('my-avatar'),
                onTap: () => unawaited(context.push(Routes.me)),
                child: TalantaAvatar(
                  name: profile?.displayName ?? '',
                  imageUrl: profile?.avatarUrl,
                  size: 34,
                ),
              ),
              const SizedBox(width: TalantaSpacing.x3),
              Expanded(
                child: Text(
                  title,
                  style: context.text.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                key: const ValueKey('open-settings'),
                tooltip: l10n.settingsTitle,
                onPressed: () => unawaited(context.push(Routes.settings)),
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReelPage extends ConsumerWidget {
  const _ReelPage({required this.postId, required this.active});

  final String postId;
  final bool active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postId));
    if (post == null || post.media.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final author = post.author;

    Future<void> like({bool onlyAdd = false}) async {
      if (onlyAdd && post.likedByMe) return;
      unawaited(HapticFeedback.lightImpact());
      try {
        await ref.read(postActionsProvider).toggleLike(post.id);
      } on ApiFailure catch (failure) {
        if (context.mounted) {
          TalantaSnack.show(context, failure.message(l10n), error: true);
        }
      }
    }

    Future<void> share() async {
      try {
        await ref.read(postActionsProvider).share(post.id);
      } on ApiFailure catch (failure) {
        if (context.mounted) {
          TalantaSnack.show(context, failure.message(l10n), error: true);
        }
      }
    }

    const shadow = [Shadow(blurRadius: 8, color: Color(0x99000000))];
    final light = context.text.bodyMedium?.copyWith(
      color: Colors.white,
      shadows: shadow,
    );

    return Stack(
      key: ValueKey('reel-${post.id}'),
      fit: StackFit.expand,
      children: [
        ReelVideo(
          url: post.media.first.url,
          active: active,
          onDoubleTap: () => like(onlyAdd: true),
        ),
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0xAA000000)],
              ),
            ),
          ),
        ),
        Positioned(
          right: TalantaSpacing.x2,
          bottom: TalantaSpacing.x8,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => openPerson(context, author, isMe: post.isMine),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: TalantaAvatar(
                    name: author.displayName,
                    imageUrl: author.avatarUrl,
                  ),
                ),
              ),
              const SizedBox(height: TalantaSpacing.x5),
              _SideAction(
                key: ValueKey('reel-like-${post.id}'),
                icon: post.likedByMe
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: post.likedByMe ? TalantaBrand.primary : Colors.white,
                count: post.likeCount,
                label: post.likedByMe ? l10n.postUnlike : l10n.postLike,
                onTap: like,
              ),
              _SideAction(
                icon: Icons.chat_bubble_outline_rounded,
                color: Colors.white,
                count: post.commentCount,
                label: l10n.postComment,
                onTap: () => unawaited(context.push(Routes.post(post.id))),
              ),
              _SideAction(
                icon: Icons.send_outlined,
                color: Colors.white,
                count: post.shareCount,
                label: l10n.postShare,
                onTap: share,
              ),
              _SideAction(
                icon: Icons.more_horiz_rounded,
                color: Colors.white,
                count: 0,
                label: l10n.postMore,
                onTap: () => unawaited(showPostMenu(context, ref, post)),
              ),
            ],
          ),
        ),
        Positioned(
          left: TalantaSpacing.x4,
          right: 84,
          bottom: TalantaSpacing.x6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => openPerson(context, author, isMe: post.isMine),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '@${author.username}',
                        overflow: TextOverflow.ellipsis,
                        style: context.text.titleMedium?.copyWith(
                          color: Colors.white,
                          shadows: shadow,
                        ),
                      ),
                    ),
                    if (author.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: TalantaBrand.gold,
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                personLine(context, author, post.createdAt),
                style: context.text.bodySmall?.copyWith(
                  color: const Color(0xCCFFFFFF),
                  shadows: shadow,
                ),
              ),
              if (post.body != null) ...[
                const SizedBox(height: TalantaSpacing.x2),
                Text.rich(
                  TextSpan(style: light, children: richText(post.body!, light)),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SideAction extends StatelessWidget {
  const _SideAction({
    required this.icon,
    required this.color,
    required this.count,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color color;
  final num count;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkResponse(
        onTap: onTap,
        radius: 30,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TalantaSpacing.x2),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
                shadows: const [
                  Shadow(blurRadius: 8, color: Color(0x99000000)),
                ],
              ),
              if (count > 0)
                Text(
                  Formatters.compact(context, count),
                  style: context.text.labelSmall?.copyWith(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyReels extends StatelessWidget {
  const _EmptyReels({required this.onPost});

  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TalantaSpacing.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: palette.outline),
              ),
              child: Center(
                child: Container(
                  width: 46,
                  height: 66,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: TalantaBrand.primary, width: 2),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: TalantaBrand.primary,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: TalantaSpacing.x6),
            Text(
              l10n.reelsEmptyTitle,
              textAlign: TextAlign.center,
              style: context.text.headlineMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: TalantaSpacing.x2),
            Text(
              l10n.reelsEmptyBody,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: TalantaSpacing.x6),
            TalantaButton(
              key: const ValueKey('post-first-reel'),
              label: l10n.reelsEmptyAction,
              icon: Icons.add_rounded,
              expand: false,
              onPressed: onPost,
            ),
          ],
        ),
      ),
    );
  }
}
