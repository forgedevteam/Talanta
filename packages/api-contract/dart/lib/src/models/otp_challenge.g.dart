// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpChallenge _$OtpChallengeFromJson(Map<String, dynamic> json) =>
    _OtpChallenge(
      phone: json['phone'] as String,
      expiresInSeconds: json['expiresInSeconds'] as num,
      resendAfterSeconds: json['resendAfterSeconds'] as num,
    );

Map<String, dynamic> _$OtpChallengeToJson(_OtpChallenge instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'expiresInSeconds': instance.expiresInSeconds,
      'resendAfterSeconds': instance.resendAfterSeconds,
    };
