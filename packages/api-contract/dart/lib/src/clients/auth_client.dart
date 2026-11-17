// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_session.dart';
import '../models/otp_challenge.dart';
import '../models/refresh_token.dart';
import '../models/request_otp.dart';
import '../models/token_pair.dart';
import '../models/verify_otp.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  /// Text a sign-in code to a phone number
  @POST('/v1/auth/otp/request')
  Future<OtpChallenge> requestOtp({
    @Body() required RequestOtp body,
  });

  /// Exchange a sign-in code for a session, creating the account if new
  @POST('/v1/auth/otp/verify')
  Future<AuthSession> verifyOtp({
    @Body() required VerifyOtp body,
  });

  /// Trade a refresh token for a new token pair
  @POST('/v1/auth/refresh')
  Future<TokenPair> refreshSession({
    @Body() required RefreshToken body,
  });

  /// End the session on this device
  @POST('/v1/auth/logout')
  Future<void> signOut({
    @Body() required RefreshToken body,
  });
}
