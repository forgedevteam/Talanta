// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'portfolio_platform.dart';

part 'portfolio_item.freezed.dart';
part 'portfolio_item.g.dart';

@Freezed()
abstract class PortfolioItem with _$PortfolioItem {
  const factory PortfolioItem({
    required String id,
    required String title,
    required String? description,
    required String url,
    required PortfolioPlatform platform,
    required String? categorySlug,
    required DateTime createdAt,
  }) = _PortfolioItem;
  
  factory PortfolioItem.fromJson(Map<String, Object?> json) => _$PortfolioItemFromJson(json);
}
