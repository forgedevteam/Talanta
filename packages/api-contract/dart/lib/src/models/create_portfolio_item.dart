// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_portfolio_item.freezed.dart';
part 'create_portfolio_item.g.dart';

@Freezed()
abstract class CreatePortfolioItem with _$CreatePortfolioItem {
  const factory CreatePortfolioItem({
    required String title,
    required String url,
    String? description,

    /// The talent this work shows.
    String? categoryId,
  }) = _CreatePortfolioItem;
  
  factory CreatePortfolioItem.fromJson(Map<String, Object?> json) => _$CreatePortfolioItemFromJson(json);
}
