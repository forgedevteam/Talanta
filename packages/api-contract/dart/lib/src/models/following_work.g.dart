// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following_work.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FollowingWork _$FollowingWorkFromJson(Map<String, dynamic> json) =>
    _FollowingWork(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      platform: PortfolioPlatform.fromJson(json['platform'] as String),
      categorySlug: json['categorySlug'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      creator: PersonSummary.fromJson(json['creator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FollowingWorkToJson(_FollowingWork instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': ?instance.description,
      'url': instance.url,
      'platform': instance.platform,
      'categorySlug': ?instance.categorySlug,
      'createdAt': instance.createdAt.toIso8601String(),
      'creator': instance.creator,
    };
