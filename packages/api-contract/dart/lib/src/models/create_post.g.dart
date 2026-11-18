// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatePost _$CreatePostFromJson(Map<String, dynamic> json) => _CreatePost(
  body: json['body'] as String?,
  mediaIds: (json['mediaIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isReel: json['isReel'] as bool?,
);

Map<String, dynamic> _$CreatePostToJson(_CreatePost instance) =>
    <String, dynamic>{
      'body': ?instance.body,
      'mediaIds': ?instance.mediaIds,
      'isReel': ?instance.isReel,
    };
