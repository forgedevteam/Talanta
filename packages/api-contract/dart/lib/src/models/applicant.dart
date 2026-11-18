// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'application_status.dart';
import 'person_summary.dart';
import 'portfolio_item.dart';

part 'applicant.freezed.dart';
part 'applicant.g.dart';

@Freezed()
abstract class Applicant with _$Applicant {
  const factory Applicant({
    required String applicationId,
    required ApplicationStatus status,
    required String message,
    required DateTime createdAt,
    required PersonSummary applicant,
    required PortfolioItem? portfolioItem,
  }) = _Applicant;
  
  factory Applicant.fromJson(Map<String, Object?> json) => _$ApplicantFromJson(json);
}
