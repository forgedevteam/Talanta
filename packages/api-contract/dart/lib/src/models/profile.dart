// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@Freezed()
abstract class Profile with _$Profile {
  const factory Profile({
    required String username,
    required String displayName,
    required String? bio,
    required String? avatarUrl,
    required String? city,
    required bool isVerified,
  }) = _Profile;
  
  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}
