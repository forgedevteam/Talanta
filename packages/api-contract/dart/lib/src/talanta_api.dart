// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/auth_client.dart';
import 'clients/me_client.dart';
import 'clients/profiles_client.dart';
import 'clients/talents_client.dart';
import 'clients/media_client.dart';
import 'clients/portfolio_client.dart';
import 'clients/posts_client.dart';
import 'clients/opportunities_client.dart';
import 'clients/creators_client.dart';
import 'clients/activity_client.dart';
import 'clients/safety_client.dart';
import 'clients/admin_client.dart';
import 'clients/promotions_client.dart';
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
  MediaClient? _media;
  PortfolioClient? _portfolio;
  PostsClient? _posts;
  OpportunitiesClient? _opportunities;
  CreatorsClient? _creators;
  ActivityClient? _activity;
  SafetyClient? _safety;
  AdminClient? _admin;
  PromotionsClient? _promotions;
  HealthClient? _health;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  MeClient get me => _me ??= MeClient(_dio, baseUrl: _baseUrl);

  ProfilesClient get profiles => _profiles ??= ProfilesClient(_dio, baseUrl: _baseUrl);

  TalentsClient get talents => _talents ??= TalentsClient(_dio, baseUrl: _baseUrl);

  MediaClient get media => _media ??= MediaClient(_dio, baseUrl: _baseUrl);

  PortfolioClient get portfolio => _portfolio ??= PortfolioClient(_dio, baseUrl: _baseUrl);

  PostsClient get posts => _posts ??= PostsClient(_dio, baseUrl: _baseUrl);

  OpportunitiesClient get opportunities => _opportunities ??= OpportunitiesClient(_dio, baseUrl: _baseUrl);

  CreatorsClient get creators => _creators ??= CreatorsClient(_dio, baseUrl: _baseUrl);

  ActivityClient get activity => _activity ??= ActivityClient(_dio, baseUrl: _baseUrl);

  SafetyClient get safety => _safety ??= SafetyClient(_dio, baseUrl: _baseUrl);

  AdminClient get admin => _admin ??= AdminClient(_dio, baseUrl: _baseUrl);

  PromotionsClient get promotions => _promotions ??= PromotionsClient(_dio, baseUrl: _baseUrl);

  HealthClient get health => _health ??= HealthClient(_dio, baseUrl: _baseUrl);
}
