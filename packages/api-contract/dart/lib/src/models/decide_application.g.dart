// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decide_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DecideApplication _$DecideApplicationFromJson(Map<String, dynamic> json) =>
    _DecideApplication(
      status: ApplicationDecision.fromJson(json['status'] as String),
    );

Map<String, dynamic> _$DecideApplicationToJson(_DecideApplication instance) =>
    <String, dynamic>{'status': instance.status};
