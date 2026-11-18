// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LikeState _$LikeStateFromJson(Map<String, dynamic> json) => _LikeState(
  liked: json['liked'] as bool,
  likeCount: json['likeCount'] as num,
);

Map<String, dynamic> _$LikeStateToJson(_LikeState instance) =>
    <String, dynamic>{'liked': instance.liked, 'likeCount': instance.likeCount};
