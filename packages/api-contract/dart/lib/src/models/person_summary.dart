// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'talent_category.dart';

part 'person_summary.freezed.dart';
part 'person_summary.g.dart';

@Freezed()
abstract class PersonSummary with _$PersonSummary {
  const factory PersonSummary({
    required String id,
    required String username,
    required String displayName,
    required String? city,
    required bool isVerified,
    required TalentCategory? primaryTalent,
  }) = _PersonSummary;
  
  factory PersonSummary.fromJson(Map<String, Object?> json) => _$PersonSummaryFromJson(json);
}
