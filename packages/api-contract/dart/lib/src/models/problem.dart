// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'error_code.dart';

part 'problem.freezed.dart';
part 'problem.g.dart';

@Freezed()
abstract class Problem with _$Problem {
  const factory Problem({
    required ErrorCode code,

    /// Developer-facing explanation. Not for display to users.
    required String message,

    /// Seconds until the request can be retried.
    num? retryAfterSeconds,

    /// Validation messages keyed by field name.
    Map<String, List<String>>? fields,
  }) = _Problem;
  
  factory Problem.fromJson(Map<String, Object?> json) => _$ProblemFromJson(json);
}
