// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerifyOtp _$VerifyOtpFromJson(Map<String, dynamic> json) => _VerifyOtp(
  phone: json['phone'] as String,
  code: json['code'] as String,
  country: json['country'] as String?,
  deviceName: json['deviceName'] as String?,
);

Map<String, dynamic> _$VerifyOtpToJson(_VerifyOtp instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'code': instance.code,
      'country': instance.country,
      'deviceName': instance.deviceName,
    };
