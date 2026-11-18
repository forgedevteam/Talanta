// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Report _$ReportFromJson(Map<String, dynamic> json) => _Report(
  id: json['id'] as String,
  targetType: ReportTarget.fromJson(json['targetType'] as String),
  targetId: json['targetId'] as String,
  reason: ReportReason.fromJson(json['reason'] as String),
  details: json['details'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ReportToJson(_Report instance) => <String, dynamic>{
  'id': instance.id,
  'targetType': instance.targetType,
  'targetId': instance.targetId,
  'reason': instance.reason,
  'details': ?instance.details,
  'createdAt': instance.createdAt.toIso8601String(),
};
