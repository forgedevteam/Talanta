// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_reason.dart';
import 'report_target.dart';

part 'report.freezed.dart';
part 'report.g.dart';

@Freezed()
abstract class Report with _$Report {
  const factory Report({
    required String id,
    required ReportTarget targetType,
    required String targetId,
    required ReportReason reason,
    required String? details,
    required DateTime createdAt,
  }) = _Report;
  
  factory Report.fromJson(Map<String, Object?> json) => _$ReportFromJson(json);
}
