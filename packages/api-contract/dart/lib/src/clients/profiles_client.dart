// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/username_availability.dart';

part 'profiles_client.g.dart';

@RestApi()
abstract class ProfilesClient {
  factory ProfilesClient(Dio dio, {String? baseUrl}) = _ProfilesClient;

  /// Check whether a username can be claimed
  @GET('/v1/profiles/username-availability')
  Future<UsernameAvailability> checkUsername({
    @Query('username') required String username,
  });
}
