// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'following_work.dart';

part 'following_feed.freezed.dart';
part 'following_feed.g.dart';

@Freezed()
abstract class FollowingFeed with _$FollowingFeed {
  const factory FollowingFeed({
    required List<FollowingWork> items,
    required String? nextCursor,
  }) = _FollowingFeed;
  
  factory FollowingFeed.fromJson(Map<String, Object?> json) => _$FollowingFeedFromJson(json);
}
