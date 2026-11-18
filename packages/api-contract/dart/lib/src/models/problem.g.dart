// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Problem _$ProblemFromJson(Map<String, dynamic> json) => _Problem(
  code: ErrorCode.fromJson(json['code'] as String),
  message: json['message'] as String,
  retryAfterSeconds: json['retryAfterSeconds'] as num?,
  fields: (json['fields'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
);

Map<String, dynamic> _$ProblemToJson(_Problem instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'retryAfterSeconds': ?instance.retryAfterSeconds,
  'fields': ?instance.fields,
};
