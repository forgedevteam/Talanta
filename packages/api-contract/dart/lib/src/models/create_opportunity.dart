// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'compensation_type.dart';

part 'create_opportunity.freezed.dart';
part 'create_opportunity.g.dart';

@Freezed()
abstract class CreateOpportunity with _$CreateOpportunity {
  const factory CreateOpportunity({
    required String title,
    required String description,
    required String categoryId,
    required String city,
    required CompensationType compensation,

    /// Required when the work is paid, so talent knows what to expect.
    num? budgetAmount,
    String? deadline,
  }) = _CreateOpportunity;
  
  factory CreateOpportunity.fromJson(Map<String, Object?> json) => _$CreateOpportunityFromJson(json);
}
