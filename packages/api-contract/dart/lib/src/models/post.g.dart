// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: json['id'] as String,
  author: PersonSummary.fromJson(json['author'] as Map<String, dynamic>),
  kind: PostKind.fromJson(json['kind'] as String),
  body: json['body'] as String?,
  media: (json['media'] as List<dynamic>)
      .map((e) => Media.fromJson(e as Map<String, dynamic>))
      .toList(),
  isReel: json['isReel'] as bool,
  likeCount: json['likeCount'] as num,
  commentCount: json['commentCount'] as num,
  shareCount: json['shareCount'] as num,
  likedByMe: json['likedByMe'] as bool,
  isMine: json['isMine'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'author': instance.author,
  'kind': instance.kind,
  'body': ?instance.body,
  'media': instance.media,
  'isReel': instance.isReel,
  'likeCount': instance.likeCount,
  'commentCount': instance.commentCount,
  'shareCount': instance.shareCount,
  'likedByMe': instance.likedByMe,
  'isMine': instance.isMine,
  'createdAt': instance.createdAt.toIso8601String(),
};
