// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creator_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatorPage _$CreatorPageFromJson(Map<String, dynamic> json) => _CreatorPage(
  items: (json['items'] as List<dynamic>)
      .map((e) => CreatorCard.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$CreatorPageToJson(_CreatorPage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': ?instance.nextCursor,
    };
