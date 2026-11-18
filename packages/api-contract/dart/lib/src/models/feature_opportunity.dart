// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_opportunity.freezed.dart';
part 'feature_opportunity.g.dart';

@Freezed()
abstract class FeatureOpportunity with _$FeatureOpportunity {
  const factory FeatureOpportunity({
    /// Days to show in the Featured row.
    required num days,
  }) = _FeatureOpportunity;
  
  factory FeatureOpportunity.fromJson(Map<String, Object?> json) => _$FeatureOpportunityFromJson(json);
}
