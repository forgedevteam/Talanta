// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateReport _$CreateReportFromJson(Map<String, dynamic> json) =>
    _CreateReport(
      targetType: ReportTarget.fromJson(json['targetType'] as String),
      targetId: json['targetId'] as String,
      reason: ReportReason.fromJson(json['reason'] as String),
      details: json['details'] as String?,
    );

Map<String, dynamic> _$CreateReportToJson(_CreateReport instance) =>
    <String, dynamic>{
      'targetType': instance.targetType,
      'targetId': instance.targetId,
      'reason': instance.reason,
      'details': ?instance.details,
    };
