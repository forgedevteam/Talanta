// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'compensation_type.dart';
import 'my_application_ref.dart';
import 'opportunity_status.dart';
import 'person_summary.dart';
import 'talent_category.dart';

part 'opportunity_detail.freezed.dart';
part 'opportunity_detail.g.dart';

@Freezed()
abstract class OpportunityDetail with _$OpportunityDetail {
  const factory OpportunityDetail({
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
    required String description,

    /// The signed-in person posted this.
    required bool isMine,
    required MyApplicationRef? myApplication,
  }) = _OpportunityDetail;
  
  factory OpportunityDetail.fromJson(Map<String, Object?> json) => _$OpportunityDetailFromJson(json);
}
