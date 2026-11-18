// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_report.dart';

part 'safety_client.g.dart';

@RestApi()
abstract class SafetyClient {
  factory SafetyClient(Dio dio, {String? baseUrl}) = _SafetyClient;

  /// Report a person, call or portfolio piece
  @POST('/v1/reports')
  Future<void> createReport({
    @Body() required CreateReport body,
  });
}
