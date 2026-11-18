import 'dart:async';

import 'package:dio/dio.dart';

/// Retries idempotent requests that failed before reaching the server or
/// with a 5xx, with a short backoff. Mobile data in our launch markets drops
/// packets often enough that this turns many visible errors into a pause.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 400),
  }) : _dio = dio;

  static const _attemptKey = 'talanta.attempt';

  final Dio _dio;
  final int maxAttempts;
  final Duration baseDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 1;
    if (!_isIdempotent(options) ||
        !_isTransient(err) ||
        attempt >= maxAttempts) {
      return handler.next(err);
    }

    await Future<void>.delayed(baseDelay * (1 << (attempt - 1)));
    options.extra[_attemptKey] = attempt + 1;
    try {
      handler.resolve(await _dio.fetch<Object?>(options));
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  bool _isIdempotent(RequestOptions options) =>
      options.method == 'GET' || options.method == 'HEAD';

  bool _isTransient(DioException error) => switch (error.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => true,
    DioExceptionType.badResponse => (error.response?.statusCode ?? 0) >= 500,
    _ => false,
  };
}
