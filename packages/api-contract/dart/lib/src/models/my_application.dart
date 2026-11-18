// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'application_status.dart';
import 'opportunity_summary.dart';

part 'my_application.freezed.dart';
part 'my_application.g.dart';

@Freezed()
abstract class MyApplication with _$MyApplication {
  const factory MyApplication({
    required String applicationId,
    required ApplicationStatus status,
    required DateTime createdAt,
    required OpportunitySummary opportunity,
  }) = _MyApplication;
  
  factory MyApplication.fromJson(Map<String, Object?> json) => _$MyApplicationFromJson(json);
}
