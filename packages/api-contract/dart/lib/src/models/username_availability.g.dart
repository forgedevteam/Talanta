// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'username_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsernameAvailability _$UsernameAvailabilityFromJson(
  Map<String, dynamic> json,
) => _UsernameAvailability(
  username: json['username'] as String,
  status: UsernameStatus.fromJson(json['status'] as String),
);

Map<String, dynamic> _$UsernameAvailabilityToJson(
  _UsernameAvailability instance,
) => <String, dynamic>{
  'username': instance.username,
  'status': instance.status,
};
