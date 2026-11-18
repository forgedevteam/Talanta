// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityPage _$ActivityPageFromJson(Map<String, dynamic> json) =>
    _ActivityPage(
      items: (json['items'] as List<dynamic>)
          .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$ActivityPageToJson(_ActivityPage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': ?instance.nextCursor,
    };
