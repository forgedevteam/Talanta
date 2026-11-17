// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/auth_client.dart';
import 'clients/me_client.dart';
import 'clients/profiles_client.dart';
import 'clients/talents_client.dart';
import 'clients/health_client.dart';

/// Talanta API `v0.1.0`.
///
/// Backend for the Talanta mobile and web apps.
class TalantaApi {
  TalantaApi(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '0.1.0';

  AuthClient? _auth;
  MeClient? _me;
  ProfilesClient? _profiles;
  TalentsClient? _talents;
  HealthClient? _health;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  MeClient get me => _me ??= MeClient(_dio, baseUrl: _baseUrl);

  ProfilesClient get profiles => _profiles ??= ProfilesClient(_dio, baseUrl: _baseUrl);

  TalentsClient get talents => _talents ??= TalentsClient(_dio, baseUrl: _baseUrl);

  HealthClient get health => _health ??= HealthClient(_dio, baseUrl: _baseUrl);
}
