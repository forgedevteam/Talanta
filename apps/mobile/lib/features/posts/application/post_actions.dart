import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/posts/application/posts_providers.dart';
import 'package:talanta_api/talanta_api.dart';

/// A photo or video picked on the phone, waiting to be posted.
class PickedMedia {
  const PickedMedia({required this.path, required this.isVideo});

  final String path;
  final bool isVideo;
}

/// How the share sheet opens. Tests record calls instead.
typedef ShareLauncher = Future<void> Function(String text);

final shareLauncherProvider = Provider<ShareLauncher>(
  (ref) =>
      (text) => SharePlus.instance.share(ShareParams(text: text)),
);

/// Likes, shares, deletes and new posts. Likes change on screen first and
/// are put back if the server says no, so tapping the heart feels instant.
class PostActions {
  const PostActions(this._ref);

  final Ref _ref;

  PostsClient get _api => _ref.read(apiProvider).posts;
  PostStore get _store => _ref.read(postStoreProvider.notifier);

  Future<void> toggleLike(String postId) async {
    final before = _ref.read(postProvider(postId));
    if (before == null) return;
    final liking = !before.likedByMe;
    _store.update(
      postId,
      (p) => p.copyWith(
        likedByMe: liking,
        likeCount: (p.likeCount + (liking ? 1 : -1)).clamp(0, double.infinity),
      ),
    );
    try {
      final result = liking
          ? await _api.likePost(id: postId)
          : await _api.unlikePost(id: postId);
      _store.update(
        postId,
        (p) => p.copyWith(likedByMe: result.liked, likeCount: result.likeCount),
      );
    } on Object catch (error) {
      _store.update(
        postId,
        (p) => p.copyWith(
          likedByMe: before.likedByMe,
          likeCount: before.likeCount,
        ),
      );
      throw ApiFailure.from(error);
    }
  }

  Future<void> share(String postId) async {
    try {
      final result = await _api.sharePost(id: postId);
      _store.update(postId, (p) => p.copyWith(shareCount: result.shareCount));
      final post = _ref.read(postProvider(postId));
      final who = post == null ? '' : '${post.author.displayName} on Talanta\n';
      await _ref.read(shareLauncherProvider)('$who${result.url}');
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  Future<void> delete(String postId) async {
    try {
      await _api.deletePost(id: postId);
      _store.remove(postId);
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  /// Uploads the files one by one, then publishes. [onProgress] runs from
  /// 0 to 1 across all files.
  Future<Post> publish({
    required String body,
    required List<PickedMedia> media,
    required bool isReel,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final ids = <String>[];
      for (var i = 0; i < media.length; i++) {
        final uploaded = await upload(
          media[i].path,
          onProgress: (fraction) =>
              onProgress?.call((i + fraction) / media.length),
        );
        ids.add(uploaded.id);
      }
      final text = body.trim();
      final post = await _api.createPost(
        body: CreatePost(
          body: text.isEmpty ? null : text,
          mediaIds: ids.isEmpty ? null : ids,
          isReel: isReel ? true : null,
        ),
      );
      _store.putAll([post]);
      _ref.read(postListProvider(forYouSource).notifier).prepend(post.id);
      _ref.read(postListProvider(followingSource).notifier).prepend(post.id);
      if (post.isReel) {
        _ref.read(postListProvider(reelsSource).notifier).prepend(post.id);
      }
      final me = _ref.read(sessionProvider);
      final username = me is SignedIn ? me.me.profile?.username : null;
      if (username != null) {
        _ref
          ..invalidate(postListProvider(creatorSource(username)))
          ..invalidate(postListProvider(creatorSource(username, reels: true)));
      }
      return post;
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  /// Sends one file. Uploads get far longer than ordinary requests: a
  /// video on a slow connection takes minutes, not seconds.
  Future<Media> upload(
    String path, {
    MediaPurpose purpose = MediaPurpose.post,
    void Function(double fraction)? onProgress,
  }) async {
    final dio = _ref.read(dioProvider);
    final response = await dio.post<Map<String, Object?>>(
      '/v1/media',
      queryParameters: {'purpose': purpose.toJson()},
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(path, filename: 'upload'),
      }),
      options: Options(
        sendTimeout: const Duration(minutes: 10),
        receiveTimeout: const Duration(minutes: 2),
      ),
      onSendProgress: (sent, total) {
        if (total > 0) onProgress?.call(sent / total);
      },
    );
    return Media.fromJson(response.data!);
  }
}

final postActionsProvider = Provider<PostActions>(PostActions.new);
