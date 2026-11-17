// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'talent_level.dart';

part 'user_talent.freezed.dart';
part 'user_talent.g.dart';

@Freezed()
abstract class UserTalent with _$UserTalent {
  const factory UserTalent({
    required String categoryId,
    required String slug,
    required String name,
    required String icon,
    required TalentLevel level,
    required bool isPrimary,
  }) = _UserTalent;
  
  factory UserTalent.fromJson(Map<String, Object?> json) => _$UserTalentFromJson(json);
}
