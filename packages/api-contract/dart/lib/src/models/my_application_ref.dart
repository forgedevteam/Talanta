// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'application_status.dart';

part 'my_application_ref.freezed.dart';
part 'my_application_ref.g.dart';

@Freezed()
abstract class MyApplicationRef with _$MyApplicationRef {
  const factory MyApplicationRef({
    required String id,
    required ApplicationStatus status,
  }) = _MyApplicationRef;
  
  factory MyApplicationRef.fromJson(Map<String, Object?> json) => _$MyApplicationRefFromJson(json);
}
