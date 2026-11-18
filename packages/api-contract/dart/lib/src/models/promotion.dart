// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion.freezed.dart';
part 'promotion.g.dart';

@Freezed()
abstract class Promotion with _$Promotion {
  const factory Promotion({
    required String id,
    required String sponsorName,
    required String title,
    required String body,
    required String ctaLabel,

    /// https:// link, or talanta:<screen> for a screen in the app.
    required String url,
  }) = _Promotion;
  
  factory Promotion.fromJson(Map<String, Object?> json) => _$PromotionFromJson(json);
}
