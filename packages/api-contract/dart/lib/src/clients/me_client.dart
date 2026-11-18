// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/me.dart';
import '../models/set_avatar.dart';
import '../models/set_talents.dart';
import '../models/update_profile.dart';

part 'me_client.g.dart';

@RestApi()
abstract class MeClient {
  factory MeClient(Dio dio, {String? baseUrl}) = _MeClient;

  /// The signed-in account, profile, talents and next onboarding step
  @GET('/v1/me')
  Future<Me> getMe();

  /// Delete my account and the data that identifies me
  @DELETE('/v1/me')
  Future<void> deleteMyAccount();

  /// Replace the talents on my profile
  @PUT('/v1/me/talents')
  Future<Me> setMyTalents({
    @Body() required SetTalents body,
  });

  /// Create or update my profile
  @PUT('/v1/me/profile')
  Future<Me> saveMyProfile({
    @Body() required UpdateProfile body,
  });

  /// Use an uploaded photo as my profile picture
  @PUT('/v1/me/avatar')
  Future<Me> setMyAvatar({
    @Body() required SetAvatar body,
  });

  /// Remove my profile picture
  @DELETE('/v1/me/avatar')
  Future<Me> removeMyAvatar();
}
