// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FollowingFeed _$FollowingFeedFromJson(Map<String, dynamic> json) =>
    _FollowingFeed(
      items: (json['items'] as List<dynamic>)
          .map((e) => FollowingWork.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$FollowingFeedToJson(_FollowingFeed instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': ?instance.nextCursor,
    };
