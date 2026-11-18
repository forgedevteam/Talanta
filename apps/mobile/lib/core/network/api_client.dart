import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talanta/core/config/app_config.dart';
import 'package:talanta/core/network/auth_interceptor.dart';
import 'package:talanta/core/network/retry_interceptor.dart';
import 'package:talanta/core/storage/token_storage.dart';
import 'package:talanta_api/talanta_api.dart';

/// Builds the one [Dio] the app talks through, and the typed client over it.
abstract final class ApiClientFactory {
  static BaseOptions _options(String baseUrl) => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: AppConfig.connectTimeout,
    receiveTimeout: AppConfig.receiveTimeout,
    headers: const {'Accept': 'application/json'},
    // Error bodies are read by the interceptors; let every status through.
    validateStatus: (status) => status != null && status < 400,
  );

  static Dio createDio({
    required TokenStorage storage,
    required void Function() onSessionEnded,
    String baseUrl = AppConfig.apiBaseUrl,
    HttpClientAdapter? adapter,
    bool logRequests = kDebugMode,
  }) {
    // A bare client for refresh calls and replays: no interceptors, so a
    // failing refresh can never trigger another refresh.
    final bare = Dio(_options(baseUrl));
    final dio = Dio(_options(baseUrl));
    if (adapter != null) {
      bare.httpClientAdapter = adapter;
      dio.httpClientAdapter = adapter;
    }

    dio.interceptors.addAll([
      RetryInterceptor(dio: bare),
      AuthInterceptor(
        storage: storage,
        refreshDio: bare,
        retryDio: bare,
        onSessionEnded: onSessionEnded,
      ),
      if (logRequests) LogInterceptor(requestHeader: false),
    ]);
    return dio;
  }

  static TalantaApi createApi(Dio dio) => TalantaApi(dio);
}
