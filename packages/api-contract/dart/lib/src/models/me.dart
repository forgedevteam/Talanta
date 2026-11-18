// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'onboarding_step.dart';
import 'profile.dart';
import 'user_role.dart';
import 'user_talent.dart';

part 'me.freezed.dart';
part 'me.g.dart';

@Freezed()
abstract class Me with _$Me {
  const factory Me({
    required String id,
    required String? phone,
    required String? country,
    required String language,
    required UserRole role,

    /// YYYY-MM-DD.
    required String? dateOfBirth,

    /// Under 18. Null until a date of birth is given.
    required bool? isMinor,
    required Profile? profile,
    required List<UserTalent> talents,

    /// The next onboarding screen to show, or `done`.
    required OnboardingStep onboardingStep,
  }) = _Me;
  
  factory Me.fromJson(Map<String, Object?> json) => _$MeFromJson(json);
}
