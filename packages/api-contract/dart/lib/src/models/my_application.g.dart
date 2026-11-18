// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyApplication _$MyApplicationFromJson(Map<String, dynamic> json) =>
    _MyApplication(
      applicationId: json['applicationId'] as String,
      status: ApplicationStatus.fromJson(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      opportunity: OpportunitySummary.fromJson(
        json['opportunity'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MyApplicationToJson(_MyApplication instance) =>
    <String, dynamic>{
      'applicationId': instance.applicationId,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'opportunity': instance.opportunity,
    };
