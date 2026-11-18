// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_talents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SetTalents _$SetTalentsFromJson(Map<String, dynamic> json) => _SetTalents(
  categoryIds: (json['categoryIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  primaryCategoryId: json['primaryCategoryId'] as String?,
);

Map<String, dynamic> _$SetTalentsToJson(_SetTalents instance) =>
    <String, dynamic>{
      'categoryIds': instance.categoryIds,
      'primaryCategoryId': ?instance.primaryCategoryId,
    };
