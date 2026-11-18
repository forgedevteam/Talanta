import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/format/formatters.dart';
import 'package:talanta/core/media/media.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/kente_strip.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/features/posts/application/post_actions.dart';
import 'package:talanta/features/posts/application/posts_providers.dart';
import 'package:talanta/features/posts/presentation/post_video.dart';
import 'package:talanta/features/safety/report_sheet.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// "Singer · Douala · 2h" under a name.
String personLine(BuildContext context, PersonSummary person, DateTime? at) {
  final l10n = AppLocalizations.of(context);
  final talent = person.primaryTalent;
  return [
    if (talent != null) TalentNames.of(l10n, talent.slug, talent.name),
    if (person.city != null && person.city!.isNotEmpty) person.city!,
    if (at != null) Formatters.ago(context, at, clock.now()),
  ].join(' · ');
}

/// Opens a person's profile: mine, or theirs.
void openPerson(
  BuildContext context,
  PersonSummary person, {
  bool isMe = false,
}) {
  unawaited(context.push(isMe ? Routes.me : Routes.creator(person.username)));
}

/// One post in a feed: who, what they shared, and what people did with it.
class PostCard extends ConsumerWidget {
  const PostCard({required this.postId, super.key, this.inDetail = false});

  final String postId;

  /// On the post's own page: the caption shows in full and the comment
  /// link is hidden, because the comments are right below.
  final bool inDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postId));
    if (post == null) return const SizedBox.shrink();
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    Future<void> like() async {
      unawaited(HapticFeedback.lightImpact());
      try {
        await ref.read(postActionsProvider).toggleLike(post.id);
      } on ApiFailure catch (failure) {
        if (context.mounted) {
          TalantaSnack.show(context, failure.message(l10n), error: true);
        }
      }
    }

    Future<void> likeOnly() async {
      if (!post.likedByMe) await like();
    }

    void openComments() {
      if (!inDetail) unawaited(context.push(Routes.post(post.id)));
    }

    return Container(
      key: ValueKey('post-${post.id}'),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(TalantaRadii.xl),
        border: Border.all(color: palette.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(post: post),
          if (post.media.isNotEmpty) ...[
            if (post.kind == PostKind.video)
              FeedVideo(url: post.media.first.url, onDoubleTap: likeOnly)
            else
              _Photos(media: post.media, onDoubleTap: likeOnly),
            const KenteStrip(),
          ] else if (post.body != null)
            _TextBody(text: post.body!, large: true, full: inDetail),
          _ActionRow(post: post, onLike: like, onComment: openComments),
          if (post.media.isNotEmpty && post.body != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TalantaSpacing.x4,
                0,
                TalantaSpacing.x4,
                TalantaSpacing.x1,
              ),
              child: _Caption(
                username: post.author.username,
                text: post.body!,
                full: inDetail,
              ),
            ),
          if (!inDetail && post.commentCount > 0)
            InkWell(
              key: ValueKey('view-comments-${post.id}'),
              onTap: openComments,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  TalantaSpacing.x4,
                  TalantaSpacing.x1,
                  TalantaSpacing.x4,
                  0,
                ),
                child: Text(
                  l10n.postViewComments(post.commentCount.toInt()),
                  style: context.text.bodyMedium?.copyWith(
                    color: palette.textMuted,
                  ),
                ),
              ),
            ),
          const SizedBox(height: TalantaSpacing.x4),
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final author = post.author;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TalantaSpacing.x4,
        TalantaSpacing.x3,
        TalantaSpacing.x1,
        TalantaSpacing.x3,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => openPerson(context, author, isMe: post.isMine),
              borderRadius: BorderRadius.circular(TalantaRadii.sm),
              child: Row(
                children: [
                  TalantaAvatar(
                    name: author.displayName,
                    imageUrl: author.avatarUrl,
                    size: 40,
                  ),
                  const SizedBox(width: TalantaSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                author.displayName,
                                style: context.text.titleSmall,
                                overflow: TextOverflow.ellipsis,
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
                        Text(
                          personLine(context, author, post.createdAt),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodySmall?.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            key: ValueKey('post-menu-${post.id}'),
            tooltip: l10n.postMore,
            onPressed: () => unawaited(showPostMenu(context, ref, post)),
            icon: Icon(Icons.more_horiz_rounded, color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Delete for my posts; report for everyone else's.
Future<void> showPostMenu(BuildContext context, WidgetRef ref, Post post) {
  final l10n = AppLocalizations.of(context);
  final palette = context.palette;
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    builder: (sheet) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.ios_share_rounded),
            title: Text(l10n.postShare),
            onTap: () {
              Navigator.of(sheet).pop();
              unawaited(_share(context, ref, post.id));
            },
          ),
          if (post.isMine)
            ListTile(
              key: const ValueKey('delete-post'),
              leading: Icon(
                Icons.delete_outline_rounded,
                color: palette.danger,
              ),
              title: Text(
                l10n.postDelete,
                style: TextStyle(color: palette.danger),
              ),
              onTap: () async {
                Navigator.of(sheet).pop();
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialog) => AlertDialog(
                    backgroundColor: palette.surface,
                    title: Text(l10n.postDeleteTitle),
                    content: Text(l10n.postDeleteBody),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialog).pop(false),
                        child: Text(l10n.commonCancel),
                      ),
                      TextButton(
                        key: const ValueKey('confirm-delete-post'),
                        onPressed: () => Navigator.of(dialog).pop(true),
                        child: Text(
                          l10n.postDelete,
                          style: TextStyle(color: palette.danger),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirmed != true || !context.mounted) return;
                try {
                  await ref.read(postActionsProvider).delete(post.id);
                  if (context.mounted) {
                    TalantaSnack.show(context, l10n.postDeleted);
                  }
                } on ApiFailure catch (failure) {
                  if (context.mounted) {
                    TalantaSnack.show(
                      context,
                      failure.message(l10n),
                      error: true,
                    );
                  }
                }
              },
            )
          else
            ListTile(
              key: const ValueKey('report-post'),
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.postReport),
              onTap: () {
                Navigator.of(sheet).pop();
                unawaited(
                  showReportSheet(
                    context,
                    target: ReportTarget.post,
                    targetId: post.id,
                  ),
                );
              },
            ),
        ],
      ),
    ),
  );
}

Future<void> _share(BuildContext context, WidgetRef ref, String postId) async {
  final l10n = AppLocalizations.of(context);
  try {
    await ref.read(postActionsProvider).share(postId);
  } on ApiFailure catch (failure) {
    if (context.mounted) {
      TalantaSnack.show(context, failure.message(l10n), error: true);
    }
  }
}

/// Swipe through photos; double tap likes.
class _Photos extends ConsumerStatefulWidget {
  const _Photos({required this.media, required this.onDoubleTap});

  final List<Media> media;
  final VoidCallback onDoubleTap;

  @override
  ConsumerState<_Photos> createState() => _PhotosState();
}

class _PhotosState extends ConsumerState<_Photos>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  late final AnimationController _heart = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void dispose() {
    _heart.dispose();
    super.dispose();
  }

  void _doubleTap() {
    widget.onDoubleTap();
    unawaited(_heart.forward(from: 0));
  }

  @override
  Widget build(BuildContext context) {
    final first = widget.media.first;
    final ratio =
        first.width != null && first.height != null && first.height! > 0
        ? (first.width! / first.height!).clamp(0.8, 1.91)
        : 1.0;
    final image = ref.watch(networkImageProvider);
    final palette = context.palette;

    return AspectRatio(
      aspectRatio: ratio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onDoubleTap: _doubleTap,
            child: PageView.builder(
              itemCount: widget.media.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) => ColoredBox(
                color: palette.surfaceRaised,
                child: Image(
                  image: image(widget.media[index].url),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: palette.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: AnimatedBuilder(
                animation: _heart,
                builder: (context, _) {
                  final t = _heart.value;
                  if (t == 0 || t == 1) return const SizedBox.shrink();
                  final scale = Curves.elasticOut.transform(
                    (t * 2).clamp(0, 1),
                  );
                  final opacity = t < 0.7 ? 1.0 : (1 - t) / 0.3;
                  return Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: 0.6 + scale * 0.6,
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 96,
                        shadows: [
                          Shadow(blurRadius: 24, color: Colors.black45),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (widget.media.length > 1) ...[
            Positioned(
              top: TalantaSpacing.x3,
              right: TalantaSpacing.x3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(TalantaRadii.pill),
                ),
                child: Text(
                  '${_page + 1}/${widget.media.length}',
                  style: context.text.labelSmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: TalantaSpacing.x3,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.media.length; i++)
                    AnimatedContainer(
                      duration: TalantaDurations.fast,
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      width: i == _page ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? TalantaBrand.primary
                            : const Color(0x99FFFFFF),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionRow extends ConsumerWidget {
  const _ActionRow({
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TalantaSpacing.x2,
        vertical: TalantaSpacing.x1,
      ),
      child: Row(
        children: [
          _Action(
            key: ValueKey('like-${post.id}'),
            icon: post.likedByMe
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: post.likedByMe ? TalantaBrand.primary : palette.text,
            count: post.likeCount,
            label: post.likedByMe ? l10n.postUnlike : l10n.postLike,
            onTap: onLike,
          ),
          _Action(
            key: ValueKey('comment-${post.id}'),
            icon: Icons.chat_bubble_outline_rounded,
            color: palette.text,
            count: post.commentCount,
            label: l10n.postComment,
            onTap: onComment,
          ),
          _Action(
            key: ValueKey('share-${post.id}'),
            icon: Icons.send_outlined,
            color: palette.text,
            count: post.shareCount,
            label: l10n.postShare,
            onTap: () => unawaited(_share(context, ref, post.id)),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
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
        radius: 28,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TalantaSpacing.x2,
            vertical: TalantaSpacing.x2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: TalantaDurations.fast,
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(icon, key: ValueKey(icon), color: color, size: 24),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Text(
                  Formatters.compact(context, count),
                  style: context.text.labelMedium?.copyWith(color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Words with hashtags and mentions picked out in orange.
List<TextSpan> richText(String text, TextStyle? base) {
  final spans = <TextSpan>[];
  final pattern = RegExp(r'([#@][\p{L}\p{N}_]+)', unicode: true);
  var index = 0;
  for (final match in pattern.allMatches(text)) {
    if (match.start > index) {
      spans.add(TextSpan(text: text.substring(index, match.start)));
    }
    spans.add(
      TextSpan(
        text: match.group(0),
        style: base?.copyWith(color: TalantaBrand.primary),
      ),
    );
    index = match.end;
  }
  if (index < text.length) spans.add(TextSpan(text: text.substring(index)));
  return spans;
}

class _TextBody extends StatelessWidget {
  const _TextBody({
    required this.text,
    required this.large,
    required this.full,
  });

  final String text;
  final bool large;
  final bool full;

  @override
  Widget build(BuildContext context) {
    // Short words-only posts read like a statement; longer ones like a note.
    final short = text.length <= 120 && !text.contains('\n');
    final style = short && large
        ? context.text.titleLarge?.copyWith(height: 1.35)
        : context.text.bodyLarge;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TalantaSpacing.x4,
        0,
        TalantaSpacing.x4,
        TalantaSpacing.x1,
      ),
      child: _Expandable(
        full: full,
        maxLines: 8,
        child: (lines) => Text.rich(
          TextSpan(style: style, children: richText(text, style)),
          maxLines: lines,
          overflow: lines == null ? null : TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption({
    required this.username,
    required this.text,
    required this.full,
  });

  final String username;
  final String text;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final base = context.text.bodyMedium;
    return _Expandable(
      full: full,
      maxLines: 2,
      child: (lines) => Text.rich(
        TextSpan(
          style: base,
          children: [
            TextSpan(
              text: '$username ',
              style: base?.copyWith(fontWeight: FontWeight.w700),
            ),
            ...richText(text, base),
          ],
        ),
        maxLines: lines,
        overflow: lines == null ? null : TextOverflow.ellipsis,
      ),
    );
  }
}

/// Long text shows its start and a "more" link.
class _Expandable extends StatefulWidget {
  const _Expandable({
    required this.child,
    required this.maxLines,
    required this.full,
  });

  final Widget Function(int? maxLines) child;
  final int maxLines;
  final bool full;

  @override
  State<_Expandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<_Expandable> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    if (widget.full || _open) return widget.child(null);
    return LayoutBuilder(
      builder: (context, constraints) {
        final collapsed = widget.child(widget.maxLines);
        return GestureDetector(
          onTap: () => setState(() => _open = true),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              collapsed,
              _MoreLink(
                maxLines: widget.maxLines,
                width: constraints.maxWidth,
                text: collapsed,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// "more", shown only when the text really is cut off.
class _MoreLink extends StatelessWidget {
  const _MoreLink({
    required this.maxLines,
    required this.width,
    required this.text,
  });

  final int maxLines;
  final double width;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    if (text is! Text) return const SizedBox.shrink();
    final rich = (text as Text).textSpan;
    if (rich == null) return const SizedBox.shrink();
    final painter = TextPainter(
      text: rich,
      maxLines: maxLines,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: width);
    final cut = painter.didExceedMaxLines;
    painter.dispose();
    if (!cut) return const SizedBox.shrink();
    return Text(
      AppLocalizations.of(context).postMoreText,
      style: context.text.bodyMedium?.copyWith(
        color: context.palette.textMuted,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
