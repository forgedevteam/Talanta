// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/media.dart';
import '../models/media_purpose.dart';

part 'media_client.g.dart';

@RestApi()
abstract class MediaClient {
  factory MediaClient(Dio dio, {String? baseUrl}) = _MediaClient;

  /// Upload a photo or a video, to attach to a post or use as my picture.
  ///
  /// [purpose] - Avatars are cropped square.
  @MultiPart()
  @POST('/v1/media')
  Future<Media> uploadMedia({
    @Part(name: 'file') required File file,
    @Query('purpose') MediaPurpose? purpose,
  });
}
