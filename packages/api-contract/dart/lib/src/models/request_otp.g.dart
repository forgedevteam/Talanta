// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestOtp _$RequestOtpFromJson(Map<String, dynamic> json) => _RequestOtp(
  phone: json['phone'] as String,
  country: json['country'] as String?,
);

Map<String, dynamic> _$RequestOtpToJson(_RequestOtp instance) =>
    <String, dynamic>{'phone': instance.phone, 'country': ?instance.country};
