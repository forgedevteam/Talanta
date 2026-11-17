// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_otp.freezed.dart';
part 'request_otp.g.dart';

@Freezed()
abstract class RequestOtp with _$RequestOtp {
  const factory RequestOtp({
    /// As typed: national format together with `country`, or full international format.
    required String phone,

    /// ISO 3166-1 alpha-2 country chosen in the picker.
    String? country,
  }) = _RequestOtp;
  
  factory RequestOtp.fromJson(Map<String, Object?> json) => _$RequestOtpFromJson(json);
}
