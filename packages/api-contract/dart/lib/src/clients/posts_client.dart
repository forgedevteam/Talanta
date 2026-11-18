// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/comment.dart';
import '../models/comment_page.dart';
import '../models/create_comment.dart';
import '../models/create_post.dart';
import '../models/feed_tab.dart';
import '../models/like_state.dart';
import '../models/post.dart';
import '../models/post_page.dart';
import '../models/share.dart';

part 'posts_client.g.dart';

@RestApi()
abstract class PostsClient {
  factory PostsClient(Dio dio, {String? baseUrl}) = _PostsClient;

  /// The home feed: everyone, or the people I follow.
  ///
  /// [cursor] - The `nextCursor` from the previous page.
  @GET('/v1/feed')
  Future<PostPage> getFeed({
    @Query('limit') num? limit = 20,
    @Query('tab') FeedTab? tab = FeedTab.forYou,
    @Query('cursor') String? cursor,
  });

  /// Short vertical videos, newest first.
  ///
  /// [cursor] - The `nextCursor` from the previous page.
  @GET('/v1/reels')
  Future<PostPage> getReels({
    @Query('limit') num? limit = 20,
    @Query('cursor') String? cursor,
  });

  /// A creator’s posts, or only their reels.
  ///
  /// [cursor] - The `nextCursor` from the previous page.
  ///
  /// [reels] - Only reels.
  @GET('/v1/creators/{username}/posts')
  Future<PostPage> getCreatorPosts({
    @Path('username') required String username,
    @Query('limit') num? limit = 20,
    @Query('cursor') String? cursor,
    @Query('reels') bool? reels,
  });

  /// Share words, photos or a video
  @POST('/v1/posts')
  Future<Post> createPost({
    @Body() required CreatePost body,
  });

  /// One post
  @GET('/v1/posts/{id}')
  Future<Post> getPost({
    @Path('id') required String id,
  });

  /// Delete my post
  @DELETE('/v1/posts/{id}')
  Future<void> deletePost({
    @Path('id') required String id,
  });

  /// Like a post
  @POST('/v1/posts/{id}/like')
  Future<LikeState> likePost({
    @Path('id') required String id,
  });

  /// Take back my like
  @DELETE('/v1/posts/{id}/like')
  Future<LikeState> unlikePost({
    @Path('id') required String id,
  });

  /// Get a link to share, and count the share
  @POST('/v1/posts/{id}/share')
  Future<Share> sharePost({
    @Path('id') required String id,
  });

  /// Comments on a post, oldest first.
  ///
  /// [cursor] - The `nextCursor` from the previous page.
  @GET('/v1/posts/{id}/comments')
  Future<CommentPage> listComments({
    @Path('id') required String id,
    @Query('limit') num? limit = 20,
    @Query('cursor') String? cursor,
  });

  /// Comment on a post
  @POST('/v1/posts/{id}/comments')
  Future<Comment> addComment({
    @Path('id') required String id,
    @Body() required CreateComment body,
  });

  /// Delete a comment I wrote, or one on my post
  @DELETE('/v1/comments/{id}')
  Future<void> deleteComment({
    @Path('id') required String id,
  });
}
