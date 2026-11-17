// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'talent_category.freezed.dart';
part 'talent_category.g.dart';

@Freezed()
abstract class TalentCategory with _$TalentCategory {
  const factory TalentCategory({
    required String id,

    /// Stable key. Safe to switch on.
    required String slug,
    required String name,

    /// Key into the client icon set.
    required String icon,
  }) = _TalentCategory;
  
  factory TalentCategory.fromJson(Map<String, Object?> json) => _$TalentCategoryFromJson(json);
}
