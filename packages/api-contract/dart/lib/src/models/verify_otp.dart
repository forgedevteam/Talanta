// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_otp.freezed.dart';
part 'verify_otp.g.dart';

@Freezed()
abstract class VerifyOtp with _$VerifyOtp {
  const factory VerifyOtp({
    /// As typed: national format together with `country`, or full international format.
    required String phone,
    required String code,

    /// ISO 3166-1 alpha-2 country chosen in the picker.
    String? country,
    String? deviceName,
  }) = _VerifyOtp;
  
  factory VerifyOtp.fromJson(Map<String, Object?> json) => _$VerifyOtpFromJson(json);
}
