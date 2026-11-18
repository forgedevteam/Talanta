// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum ErrorCode {
  @JsonValue('validation_failed')
  validationFailed('validation_failed'),
  @JsonValue('unauthorized')
  unauthorized('unauthorized'),
  @JsonValue('forbidden')
  forbidden('forbidden'),
  @JsonValue('not_found')
  notFound('not_found'),
  @JsonValue('conflict')
  conflict('conflict'),
  @JsonValue('rate_limited')
  rateLimited('rate_limited'),
  @JsonValue('internal_error')
  internalError('internal_error'),
  @JsonValue('service_unavailable')
  serviceUnavailable('service_unavailable'),
  @JsonValue('phone_invalid')
  phoneInvalid('phone_invalid'),
  @JsonValue('phone_country_unsupported')
  phoneCountryUnsupported('phone_country_unsupported'),
  @JsonValue('otp_resend_too_soon')
  otpResendTooSoon('otp_resend_too_soon'),
  @JsonValue('otp_rate_limited')
  otpRateLimited('otp_rate_limited'),
  @JsonValue('otp_invalid')
  otpInvalid('otp_invalid'),
  @JsonValue('otp_expired')
  otpExpired('otp_expired'),
  @JsonValue('otp_too_many_attempts')
  otpTooManyAttempts('otp_too_many_attempts'),
  @JsonValue('sms_delivery_failed')
  smsDeliveryFailed('sms_delivery_failed'),
  @JsonValue('session_expired')
  sessionExpired('session_expired'),
  @JsonValue('account_suspended')
  accountSuspended('account_suspended'),
  @JsonValue('username_taken')
  usernameTaken('username_taken'),
  @JsonValue('username_reserved')
  usernameReserved('username_reserved'),
  @JsonValue('talent_category_unknown')
  talentCategoryUnknown('talent_category_unknown'),
  @JsonValue('age_below_minimum')
  ageBelowMinimum('age_below_minimum'),
  @JsonValue('adults_only')
  adultsOnly('adults_only'),
  @JsonValue('profile_required')
  profileRequired('profile_required'),
  @JsonValue('opportunity_closed')
  opportunityClosed('opportunity_closed'),
  @JsonValue('already_applied')
  alreadyApplied('already_applied'),
  @JsonValue('cannot_apply_to_own')
  cannotApplyToOwn('cannot_apply_to_own'),
  @JsonValue('cannot_follow_self')
  cannotFollowSelf('cannot_follow_self'),
  @JsonValue('link_not_allowed')
  linkNotAllowed('link_not_allowed'),
  @JsonValue('limit_reached')
  limitReached('limit_reached'),
  @JsonValue('media_unsupported')
  mediaUnsupported('media_unsupported'),
  @JsonValue('media_too_large')
  mediaTooLarge('media_too_large'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ErrorCode(this.json);

  factory ErrorCode.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
  String toJson() {
    final value = json;
    if (value == null) {
      throw StateError('Cannot convert enum value with null JSON representation to String. '
          'This usually happens for \$unknown or @JsonValue(null) entries.');
    }
    return value as String;
  }

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<ErrorCode> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
