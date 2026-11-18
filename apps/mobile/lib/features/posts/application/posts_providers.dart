import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta_api/talanta_api.dart';

/// The latest copy of every post on screen, by id. Lists hold ids only, so
/// a like on the home feed shows on the profile and in Reels at once.
class PostStore extends Notifier<Map<String, Post>> {
  @override
  Map<String, Post> build() => const {};

  void putAll(Iterable<Post> posts) {
    if (posts.isEmpty) return;
    state = {...state, for (final post in posts) post.id: post};
  }

  void update(String id, Post Function(Post post) change) {
    final current = state[id];
    if (current == null) return;
    state = {...state, id: change(current)};
  }

  void remove(String id) {
    if (!state.containsKey(id)) return;
    state = {...state}..remove(id);
  }
}

final postStoreProvider = NotifierProvider<PostStore, Map<String, Post>>(
  PostStore.new,
);

final postProvider = Provider.family<Post?, String>(
  (ref, id) => ref.watch(postStoreProvider.select((posts) => posts[id])),
);

/// Which list of posts to show.
enum PostFeed { forYou, following, reels, creator, creatorReels }

typedef PostSource = ({PostFeed feed, String? username});

const forYouSource = (feed: PostFeed.forYou, username: null);
const followingSource = (feed: PostFeed.following, username: null);
const reelsSource = (feed: PostFeed.reels, username: null);
PostSource creatorSource(String username, {bool reels = false}) => (
  feed: reels ? PostFeed.creatorReels : PostFeed.creator,
  username: username,
);

class PostListState {
  const PostListState({
    this.ids = const [],
    this.nextCursor,
    this.loading = true,
    this.loadingMore = false,
    this.error,
  });

  final List<String> ids;
  final String? nextCursor;
  final bool loading;
  final bool loadingMore;
  final ApiFailure? error;

  bool get hasMore => nextCursor != null;

  PostListState copyWith({
    List<String>? ids,
    String? nextCursor,
    bool clearCursor = false,
    bool? loading,
    bool? loadingMore,
    ApiFailure? error,
    bool clearError = false,
  }) => PostListState(
    ids: ids ?? this.ids,
    nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : (error ?? this.error),
  );
}

/// One pageable list of posts: a feed, Reels, or a creator's grid.
class PostListController extends Notifier<PostListState> {
  PostListController(this.source);

  final PostSource source;

  @override
  PostListState build() {
    // Deleted posts leave every list at once.
    ref.listen(postStoreProvider, (previous, next) {
      final missing = state.ids.where(
        (id) => (previous?.containsKey(id) ?? false) && !next.containsKey(id),
      );
      if (missing.isNotEmpty) {
        final gone = missing.toSet();
        state = state.copyWith(
          ids: state.ids.where((id) => !gone.contains(id)).toList(),
        );
      }
    });
    unawaited(Future<void>.microtask(refresh));
    return const PostListState();
  }

  Future<PostPage> _fetch(String? cursor) {
    final api = ref.read(apiProvider).posts;
    return switch (source.feed) {
      PostFeed.forYou => api.getFeed(cursor: cursor),
      PostFeed.following => api.getFeed(tab: FeedTab.following, cursor: cursor),
      PostFeed.reels => api.getReels(cursor: cursor),
      PostFeed.creator => api.getCreatorPosts(
        username: source.username!,
        cursor: cursor,
      ),
      PostFeed.creatorReels => api.getCreatorPosts(
        username: source.username!,
        reels: true,
        cursor: cursor,
      ),
    };
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final page = await _fetch(null);
      ref.read(postStoreProvider.notifier).putAll(page.items);
      state = PostListState(
        ids: [for (final post in page.items) post.id],
        nextCursor: page.nextCursor,
        loading: false,
      );
    } on Object catch (error) {
      state = state.copyWith(loading: false, error: ApiFailure.from(error));
    }
  }

  Future<void> loadMore() async {
    final cursor = state.nextCursor;
    if (cursor == null || state.loading || state.loadingMore) return;
    state = state.copyWith(loadingMore: true);
    try {
      final page = await _fetch(cursor);
      ref.read(postStoreProvider.notifier).putAll(page.items);
      final seen = state.ids.toSet();
      state = state.copyWith(
        ids: [
          ...state.ids,
          for (final post in page.items)
            if (!seen.contains(post.id)) post.id,
        ],
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
        loadingMore: false,
      );
    } on Object {
      // Scrolling again retries.
      state = state.copyWith(loadingMore: false);
    }
  }

  /// A post the person just made goes to the top straight away.
  void prepend(String id) {
    if (state.ids.contains(id)) return;
    state = state.copyWith(ids: [id, ...state.ids]);
  }
}

final postListProvider =
    NotifierProvider.family<PostListController, PostListState, PostSource>(
      PostListController.new,
    );

/// Comments on one post, oldest first.
class CommentsState {
  const CommentsState({
    this.items = const [],
    this.nextCursor,
    this.loading = true,
    this.error,
  });

  final List<Comment> items;
  final String? nextCursor;
  final bool loading;
  final ApiFailure? error;
}

class CommentsController extends Notifier<CommentsState> {
  CommentsController(this.postId);

  final String postId;

  PostsClient get _api => ref.read(apiProvider).posts;

  @override
  CommentsState build() {
    unawaited(Future<void>.microtask(refresh));
    return const CommentsState();
  }

  Future<void> refresh() async {
    try {
      final page = await _api.listComments(id: postId, limit: 50);
      state = CommentsState(
        items: page.items,
        nextCursor: page.nextCursor,
        loading: false,
      );
    } on Object catch (error) {
      state = CommentsState(loading: false, error: ApiFailure.from(error));
    }
  }

  Future<void> loadMore() async {
    final cursor = state.nextCursor;
    if (cursor == null) return;
    try {
      final page = await _api.listComments(
        id: postId,
        cursor: cursor,
        limit: 50,
      );
      state = CommentsState(
        items: [...state.items, ...page.items],
        nextCursor: page.nextCursor,
        loading: false,
      );
    } on Object {
      // Tapping again retries.
    }
  }

  Future<void> add(String body) async {
    try {
      final comment = await _api.addComment(
        id: postId,
        body: CreateComment(body: body),
      );
      state = CommentsState(
        items: [...state.items, comment],
        nextCursor: state.nextCursor,
        loading: false,
      );
      ref
          .read(postStoreProvider.notifier)
          .update(postId, (p) => p.copyWith(commentCount: p.commentCount + 1));
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  Future<void> delete(String commentId) async {
    try {
      await _api.deleteComment(id: commentId);
      state = CommentsState(
        items: state.items.where((c) => c.id != commentId).toList(),
        nextCursor: state.nextCursor,
        loading: false,
      );
      ref
          .read(postStoreProvider.notifier)
          .update(
            postId,
            (p) => p.copyWith(
              commentCount: (p.commentCount - 1).clamp(0, double.infinity),
            ),
          );
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }
}

final commentsProvider = NotifierProvider.autoDispose
    .family<CommentsController, CommentsState, String>(CommentsController.new);

/// One post opened on its own, e.g. from a notification.
final postByIdProvider = FutureProvider.autoDispose.family<Post, String>((
  ref,
  id,
) async {
  final post = await ref.read(apiProvider).posts.getPost(id: id);
  ref.read(postStoreProvider.notifier).putAll([post]);
  return post;
});
