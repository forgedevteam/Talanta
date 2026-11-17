// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_talents.freezed.dart';
part 'set_talents.g.dart';

@Freezed()
abstract class SetTalents with _$SetTalents {
  const factory SetTalents({
    /// Replaces the full list.
    required List<String> categoryIds,

    /// The talent shown first on the profile. Defaults to the first id in the list.
    String? primaryCategoryId,
  }) = _SetTalents;
  
  factory SetTalents.fromJson(Map<String, Object?> json) => _$SetTalentsFromJson(json);
}
