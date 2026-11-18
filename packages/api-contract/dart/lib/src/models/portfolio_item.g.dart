// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PortfolioItem _$PortfolioItemFromJson(Map<String, dynamic> json) =>
    _PortfolioItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      platform: PortfolioPlatform.fromJson(json['platform'] as String),
      categorySlug: json['categorySlug'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PortfolioItemToJson(_PortfolioItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': ?instance.description,
      'url': instance.url,
      'platform': instance.platform,
      'categorySlug': ?instance.categorySlug,
      'createdAt': instance.createdAt.toIso8601String(),
    };
