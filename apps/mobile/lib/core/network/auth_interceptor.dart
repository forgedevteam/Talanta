import 'package:dio/dio.dart';
import 'package:talanta/core/storage/token_storage.dart';
import 'package:talanta_api/talanta_api.dart';

/// Attaches the access token and, on a 401, refreshes it once and replays
/// the request. A [QueuedInterceptor] handles one request at a time, so a
/// burst of 401s results in a single refresh rather than a race.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStorage storage,
    required Dio refreshDio,
    required Dio retryDio,
    required void Function() onSessionEnded,
  }) : _storage = storage,
       _refresh = AuthClient(refreshDio),
       _retryDio = retryDio,
       _onSessionEnded = onSessionEnded;

  static const _retriedFlag = 'talanta.retried';

  final TokenStorage _storage;
  final AuthClient _refresh;
  final Dio _retryDio;
  final void Function() _onSessionEnded;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tokens = await _storage.read();
    if (tokens != null && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isAuthRoute = err.requestOptions.path.startsWith('/v1/auth/');
    final alreadyRetried = err.requestOptions.extra[_retriedFlag] == true;
    if (!isUnauthorized || isAuthRoute || alreadyRetried) {
      return handler.next(err);
    }

    final current = await _storage.read();
    if (current == null) return handler.next(err);

    // Another queued request may have refreshed already; if the stored
    // token differs from the one that failed, just replay with it.
    final failedWith = err.requestOptions.headers['Authorization'];
    if (failedWith != 'Bearer ${current.accessToken}') {
      return _replay(err.requestOptions, current.accessToken, handler);
    }

    try {
      final pair = await _refresh.refreshSession(
        body: RefreshToken(refreshToken: current.refreshToken),
      );
      final fresh = StoredTokens(
        accessToken: pair.accessToken,
        refreshToken: pair.refreshToken,
      );
      await _storage.write(fresh);
      return _replay(err.requestOptions, fresh.accessToken, handler);
    } on DioException catch (refreshError) {
      final status = refreshError.response?.statusCode ?? 0;
      if (status == 401 || status == 403) {
        await _storage.clear();
        _onSessionEnded();
      }
      return handler.next(err);
    }
  }

  Future<void> _replay(
    RequestOptions options,
    String accessToken,
    ErrorInterceptorHandler handler,
  ) async {
    options.headers['Authorization'] = 'Bearer $accessToken';
    options.extra[_retriedFlag] = true;
    try {
      final response = await _retryDio.fetch<Object?>(options);
      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }
}
