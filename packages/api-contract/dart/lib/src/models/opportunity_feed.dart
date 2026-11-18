// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'opportunity_summary.dart';

part 'opportunity_feed.freezed.dart';
part 'opportunity_feed.g.dart';

@Freezed()
abstract class OpportunityFeed with _$OpportunityFeed {
  const factory OpportunityFeed({
    /// Paid placements, only on the first page.
    required List<OpportunitySummary> featured,
    required List<OpportunitySummary> items,
    required String? nextCursor,
  }) = _OpportunityFeed;
  
  factory OpportunityFeed.fromJson(Map<String, Object?> json) => _$OpportunityFeedFromJson(json);
}
