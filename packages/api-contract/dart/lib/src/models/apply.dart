// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply.freezed.dart';
part 'apply.g.dart';

@Freezed()
abstract class Apply with _$Apply {
  const factory Apply({
    required String message,

    /// A piece from your portfolio to show.
    String? portfolioItemId,
  }) = _Apply;
  
  factory Apply.fromJson(Map<String, Object?> json) => _$ApplyFromJson(json);
}
