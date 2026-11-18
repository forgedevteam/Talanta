// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'application_decision.dart';

part 'decide_application.freezed.dart';
part 'decide_application.g.dart';

@Freezed()
abstract class DecideApplication with _$DecideApplication {
  const factory DecideApplication({
    required ApplicationDecision status,
  }) = _DecideApplication;
  
  factory DecideApplication.fromJson(Map<String, Object?> json) => _$DecideApplicationFromJson(json);
}
