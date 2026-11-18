// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile.freezed.dart';
part 'update_profile.g.dart';

@Freezed()
abstract class UpdateProfile with _$UpdateProfile {
  const factory UpdateProfile({
    required String displayName,
    required String username,
    required String city,
    String? bio,

    /// YYYY-MM-DD. Required the first time a profile is saved, and cannot be changed afterwards.
    String? dateOfBirth,
  }) = _UpdateProfile;
  
  factory UpdateProfile.fromJson(Map<String, Object?> json) => _$UpdateProfileFromJson(json);
}
