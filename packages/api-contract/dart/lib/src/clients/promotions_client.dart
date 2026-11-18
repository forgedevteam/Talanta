// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_promotion.dart';
import '../models/promotion.dart';
import '../models/promotion_placement.dart';

part 'promotions_client.g.dart';

@RestApi()
abstract class PromotionsClient {
  factory PromotionsClient(Dio dio, {String? baseUrl}) = _PromotionsClient;

  /// Sponsored cards running now for a placement
  @GET('/v1/promotions')
  Future<List<Promotion>> listPromotions({
    @Query('placement') required PromotionPlacement placement,
  });

  /// Schedule a sponsored card
  @POST('/v1/admin/promotions')
  Future<Promotion> createPromotion({
    @Body() required CreatePromotion body,
  });
}
