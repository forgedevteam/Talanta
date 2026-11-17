// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talent_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TalentCategory _$TalentCategoryFromJson(Map<String, dynamic> json) =>
    _TalentCategory(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$TalentCategoryToJson(_TalentCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'icon': instance.icon,
    };
