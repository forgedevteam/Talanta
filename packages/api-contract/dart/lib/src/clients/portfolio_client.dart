// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_portfolio_item.dart';
import '../models/portfolio_item.dart';

part 'portfolio_client.g.dart';

@RestApi()
abstract class PortfolioClient {
  factory PortfolioClient(Dio dio, {String? baseUrl}) = _PortfolioClient;

  /// My portfolio, newest first
  @GET('/v1/me/portfolio')
  Future<List<PortfolioItem>> listMyPortfolio();

  /// Add a link to a piece of my work
  @POST('/v1/me/portfolio')
  Future<PortfolioItem> addPortfolioItem({
    @Body() required CreatePortfolioItem body,
  });

  /// Remove a piece from my portfolio
  @DELETE('/v1/me/portfolio/{id}')
  Future<void> removePortfolioItem({
    @Path('id') required String id,
  });
}
