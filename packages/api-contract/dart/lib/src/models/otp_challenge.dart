// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_challenge.freezed.dart';
part 'otp_challenge.g.dart';

@Freezed()
abstract class OtpChallenge with _$OtpChallenge {
  const factory OtpChallenge({
    /// The number the code was sent to, in E.164.
    required String phone,
    required num expiresInSeconds,

    /// How long to wait before asking for another code.
    required num resendAfterSeconds,
  }) = _OtpChallenge;
  
  factory OtpChallenge.fromJson(Map<String, Object?> json) => _$OtpChallengeFromJson(json);
}
