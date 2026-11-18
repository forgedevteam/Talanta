// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_portfolio_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatePortfolioItem _$CreatePortfolioItemFromJson(Map<String, dynamic> json) =>
    _CreatePortfolioItem(
      title: json['title'] as String,
      url: json['url'] as String,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String?,
    );

Map<String, dynamic> _$CreatePortfolioItemToJson(
  _CreatePortfolioItem instance,
) => <String, dynamic>{
  'title': instance.title,
  'url': instance.url,
  'description': ?instance.description,
  'categoryId': ?instance.categoryId,
};
