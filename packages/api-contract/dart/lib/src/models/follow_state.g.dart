// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FollowState _$FollowStateFromJson(Map<String, dynamic> json) => _FollowState(
  isFollowing: json['isFollowing'] as bool,
  followerCount: json['followerCount'] as num,
);

Map<String, dynamic> _$FollowStateToJson(_FollowState instance) =>
    <String, dynamic>{
      'isFollowing': instance.isFollowing,
      'followerCount': instance.followerCount,
    };
