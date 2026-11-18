// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_reason.dart';
import 'report_target.dart';

part 'create_report.freezed.dart';
part 'create_report.g.dart';

@Freezed()
abstract class CreateReport with _$CreateReport {
  const factory CreateReport({
    required ReportTarget targetType,

    /// For a user, their username is resolved by the client to the id shown on cards.
    required String targetId,
    required ReportReason reason,
    String? details,
  }) = _CreateReport;
  
  factory CreateReport.fromJson(Map<String, Object?> json) => _$CreateReportFromJson(json);
}
