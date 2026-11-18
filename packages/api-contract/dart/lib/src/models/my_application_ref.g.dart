// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_application_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyApplicationRef _$MyApplicationRefFromJson(Map<String, dynamic> json) =>
    _MyApplicationRef(
      id: json['id'] as String,
      status: ApplicationStatus.fromJson(json['status'] as String),
    );

Map<String, dynamic> _$MyApplicationRefToJson(_MyApplicationRef instance) =>
    <String, dynamic>{'id': instance.id, 'status': instance.status};
