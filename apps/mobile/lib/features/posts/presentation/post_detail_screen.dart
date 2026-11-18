import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/format/formatters.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/posts/application/posts_providers.dart';
import 'package:talanta/features/posts/presentation/post_card.dart';
import 'package:talanta/features/safety/report_sheet.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// A post on its own page, with the conversation under it.
class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({required this.postId, super.key});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cached = ref.watch(postProvider(postId));
    // Opened from a notification or a link: fetch it first.
    final loaded = cached == null ? ref.watch(postByIdProvider(postId)) : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.postTitle)),
      body: cached != null
          ? _Body(postId: postId)
          : loaded!.when(
              data: (_) => _Body(postId: postId),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => TalantaErrorState(
                error: error,
                onRetry: () => ref.invalidate(postByIdProvider(postId)),
              ),
            ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final comments = ref.watch(commentsProvider(postId));
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(TalantaSpacing.x3),
                sliver: SliverToBoxAdapter(
                  child: PostCard(postId: postId, inDetail: true),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    TalantaSpacing.x4,
                    TalantaSpacing.x2,
                    TalantaSpacing.x4,
                    TalantaSpacing.x2,
                  ),
                  child: Text(
                    l10n.commentsTitle,
                    style: context.text.titleMedium,
                  ),
                ),
              ),
              if (comments.loading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(TalantaSpacing.x6),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (comments.error != null)
                SliverToBoxAdapter(
                  child: TalantaErrorState(
                    error: comments.error!,
                    onRetry: () =>
                        ref.read(commentsProvider(postId).notifier).refresh(),
                  ),
                )
              else if (comments.items.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(TalantaSpacing.x6),
                    child: Text(
                      l10n.commentsEmpty,
                      textAlign: TextAlign.center,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.palette.textMuted,
                      ),
                    ),
                  ),
                )
              else ...[
                SliverList.builder(
                  itemCount: comments.items.length,
                  itemBuilder: (context, index) => _CommentTile(
                    comment: comments.items[index],
                    postId: postId,
                  ),
                ),
                if (comments.nextCursor != null)
                  SliverToBoxAdapter(
                    child: TextButton(
                      onPressed: () => ref
                          .read(commentsProvider(postId).notifier)
                          .loadMore(),
                      child: Text(l10n.commentsMore),
                    ),
                  ),
              ],
              const SliverToBoxAdapter(
                child: SizedBox(height: TalantaSpacing.x6),
              ),
            ],
          ),
        ),
        _CommentInput(postId: postId),
      ],
    );
  }
}

class _CommentTile extends ConsumerWidget {
  const _CommentTile({required this.comment, required this.postId});

  final Comment comment;
  final String postId;

  Future<void> _menu(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (comment.canDelete)
              ListTile(
                key: const ValueKey('delete-comment'),
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: palette.danger,
                ),
                title: Text(
                  l10n.commentDelete,
                  style: TextStyle(color: palette.danger),
                ),
                onTap: () async {
                  Navigator.of(sheet).pop();
                  try {
                    await ref
                        .read(commentsProvider(postId).notifier)
                        .delete(comment.id);
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
              ),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.commentReport),
              onTap: () {
                Navigator.of(sheet).pop();
                unawaited(
                  showReportSheet(
                    context,
                    target: ReportTarget.comment,
                    targetId: comment.id,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final author = comment.author;
    final post = ref.watch(postProvider(postId));
    final isAuthorOfPost = post?.author.id == author.id;
    final session = ref.watch(sessionProvider);
    final isMe = session is SignedIn && session.me.id == author.id;

    return InkWell(
      onLongPress: () => unawaited(_menu(context, ref)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TalantaSpacing.x4,
          vertical: TalantaSpacing.x2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => openPerson(context, author, isMe: isMe),
              child: TalantaAvatar(
                name: author.displayName,
                imageUrl: author.avatarUrl,
                size: 34,
              ),
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
                          author.username,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.labelMedium,
                        ),
                      ),
                      if (isAuthorOfPost) ...[
                        const SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context).commentAuthorBadge,
                          style: context.text.labelSmall?.copyWith(
                            color: TalantaBrand.primary,
                          ),
                        ),
                      ],
                      const SizedBox(width: 6),
                      Text(
                        Formatters.ago(context, comment.createdAt, clock.now()),
                        style: context.text.labelSmall?.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      style: context.text.bodyMedium,
                      children: richText(comment.body, context.text.bodyMedium),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => unawaited(_menu(context, ref)),
              icon: Icon(
                Icons.more_horiz_rounded,
                size: 18,
                color: palette.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentInput extends ConsumerStatefulWidget {
  const _CommentInput({required this.postId});

  final String postId;

  @override
  ConsumerState<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<_CommentInput> {
  final _text = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _text.text.trim();
    if (body.isEmpty || _busy) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(commentsProvider(widget.postId).notifier).add(body);
      _text.clear();
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
    final session = ref.watch(sessionProvider);
    final profile = session is SignedIn ? session.me.profile : null;
    final canSend = _text.text.trim().isNotEmpty && !_busy;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.background,
        border: Border(top: BorderSide(color: palette.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            TalantaSpacing.x3,
            TalantaSpacing.x2,
            TalantaSpacing.x2,
            TalantaSpacing.x2,
          ),
          child: Row(
            children: [
              TalantaAvatar(
                name: profile?.displayName ?? '',
                imageUrl: profile?.avatarUrl,
                size: 34,
              ),
              const SizedBox(width: TalantaSpacing.x2),
              Expanded(
                child: TextField(
                  key: const ValueKey('comment-field'),
                  controller: _text,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: l10n.commentHint,
                    counterText: '',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: TalantaSpacing.x4,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TalantaRadii.pill),
                      borderSide: BorderSide(color: palette.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TalantaRadii.pill),
                      borderSide: BorderSide(color: palette.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TalantaRadii.pill),
                      borderSide: const BorderSide(color: TalantaBrand.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: TalantaSpacing.x2),
              AnimatedOpacity(
                duration: TalantaDurations.fast,
                opacity: canSend ? 1 : 0.4,
                child: IconButton.filled(
                  key: const ValueKey('send-comment'),
                  tooltip: l10n.commentSend,
                  style: IconButton.styleFrom(
                    backgroundColor: TalantaBrand.primary,
                    foregroundColor: palette.onPrimary,
                  ),
                  onPressed: canSend ? _send : null,
                  icon: _busy
                      ? SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: palette.onPrimary,
                          ),
                        )
                      : const Icon(Icons.arrow_upward_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
