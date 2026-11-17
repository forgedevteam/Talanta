// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_talent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserTalent _$UserTalentFromJson(Map<String, dynamic> json) => _UserTalent(
  categoryId: json['categoryId'] as String,
  slug: json['slug'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String,
  level: TalentLevel.fromJson(json['level'] as String),
  isPrimary: json['isPrimary'] as bool,
);

Map<String, dynamic> _$UserTalentToJson(_UserTalent instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'slug': instance.slug,
      'name': instance.name,
      'icon': instance.icon,
      'level': instance.level,
      'isPrimary': instance.isPrimary,
    };
