// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/creator_page.dart';
import '../models/creator_profile.dart';
import '../models/follow_state.dart';
import '../models/following_feed.dart';

part 'creators_client.g.dart';

@RestApi()
abstract class CreatorsClient {
  factory CreatorsClient(Dio dio, {String? baseUrl}) = _CreatorsClient;

  /// Find creators by name, talent and city.
  ///
  /// [cursor] - The `nextCursor` from the previous page.
  ///
  /// [q] - Matches username or display name.
  @GET('/v1/creators')
  Future<CreatorPage> searchCreators({
    @Query('limit') num? limit = 20,
    @Query('cursor') String? cursor,
    @Query('q') String? q,
    @Query('talent') String? talent,
    @Query('city') String? city,
  });

  /// A creator’s public profile and portfolio
  @GET('/v1/creators/{username}')
  Future<CreatorProfile> getCreator({
    @Path('username') required String username,
  });

  /// Follow a creator
  @POST('/v1/creators/{username}/follow')
  Future<FollowState> followCreator({
    @Path('username') required String username,
  });

  /// Stop following a creator
  @DELETE('/v1/creators/{username}/follow')
  Future<FollowState> unfollowCreator({
    @Path('username') required String username,
  });

  /// New work from the creators I follow.
  ///
  /// [cursor] - The `nextCursor` from the previous page.
  @GET('/v1/feed/following')
  Future<FollowingFeed> getFollowingFeed({
    @Query('limit') num? limit = 20,
    @Query('cursor') String? cursor,
  });
}
