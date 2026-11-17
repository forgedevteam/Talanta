// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/talent_category.dart';

part 'talents_client.g.dart';

@RestApi()
abstract class TalentsClient {
  factory TalentsClient(Dio dio, {String? baseUrl}) = _TalentsClient;

  /// List the talent categories people can pick from
  @GET('/v1/talent-categories')
  Future<List<TalentCategory>> listTalentCategories();
}
