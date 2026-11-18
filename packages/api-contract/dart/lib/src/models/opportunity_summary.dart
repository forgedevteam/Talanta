// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'compensation_type.dart';
import 'opportunity_status.dart';
import 'person_summary.dart';
import 'talent_category.dart';

part 'opportunity_summary.freezed.dart';
part 'opportunity_summary.g.dart';

@Freezed()
abstract class OpportunitySummary with _$OpportunitySummary {
  const factory OpportunitySummary({
    required String id,
    required String title,
    required TalentCategory category,
    required String city,
    required String country,
    required CompensationType compensation,
    required num? budgetAmount,
    required String currency,

    /// YYYY-MM-DD.
    required String? deadline,
    required OpportunityStatus status,

    /// Paid placement. Show with a Featured label.
    required bool isFeatured,
    required num applicationsCount,
    required PersonSummary? poster,
    required DateTime createdAt,
  }) = _OpportunitySummary;
  
  factory OpportunitySummary.fromJson(Map<String, Object?> json) => _$OpportunitySummaryFromJson(json);
}
