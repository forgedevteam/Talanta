// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/activity_page.dart';
import '../models/unread_count.dart';

part 'activity_client.g.dart';

@RestApi()
abstract class ActivityClient {
  factory ActivityClient(Dio dio, {String? baseUrl}) = _ActivityClient;

  /// My notifications, newest first.
  ///
  /// [cursor] - The `nextCursor` from the previous page.
  @GET('/v1/me/notifications')
  Future<ActivityPage> listNotifications({
    @Query('limit') num? limit = 20,
    @Query('cursor') String? cursor,
  });

  /// How many notifications I have not seen
  @GET('/v1/me/notifications/unread-count')
  Future<UnreadCount> getUnreadCount();

  /// Mark all my notifications as seen
  @POST('/v1/me/notifications/read-all')
  Future<void> markAllRead();
}
