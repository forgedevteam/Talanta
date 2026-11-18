// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'media_kind.dart';

part 'media.freezed.dart';
part 'media.g.dart';

@Freezed()
abstract class Media with _$Media {
  const factory Media({
    required String id,
    required MediaKind kind,

    /// Absolute, or relative to the API origin.
    required String url,
    required num? width,
    required num? height,
  }) = _Media;
  
  factory Media.fromJson(Map<String, Object?> json) => _$MediaFromJson(json);
}
