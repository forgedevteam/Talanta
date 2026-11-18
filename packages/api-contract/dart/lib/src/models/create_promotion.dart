// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'promotion_placement.dart';

part 'create_promotion.freezed.dart';
part 'create_promotion.g.dart';

@Freezed()
abstract class CreatePromotion with _$CreatePromotion {
  const factory CreatePromotion({
    required PromotionPlacement placement,
    required String sponsorName,
    required String title,
    required String body,
    required String ctaLabel,
    required String url,
    required DateTime startsAt,
    required DateTime endsAt,
  }) = _CreatePromotion;
  
  factory CreatePromotion.fromJson(Map<String, Object?> json) => _$CreatePromotionFromJson(json);
}
