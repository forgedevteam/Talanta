import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talanta/core/network/api_client.dart';
import 'package:talanta/core/storage/token_storage.dart';

/// Answers 401 to any `/v1/me` call with a token other than [accepted].
class _RefreshingServer implements HttpClientAdapter {
  _RefreshingServer({required this.accepted, this.refreshStatus = 200});

  final String accepted;
  final int refreshStatus;
  int refreshCalls = 0;
  final List<String> authHeaders = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    const json = {
      'content-type': ['application/json'],
    };
    if (options.path == '/v1/auth/refresh') {
      refreshCalls += 1;
      if (refreshStatus != 200) {
        return ResponseBody.fromString(
          '{"code":"session_expired","message":"ended"}',
          refreshStatus,
          headers: json,
        );
      }
      return ResponseBody.fromString(
        '{"accessToken":"$accepted","refreshToken":"refresh-2","accessTokenExpiresIn":900}',
        200,
        headers: json,
      );
    }
    final auth = options.headers['Authorization'] as String?;
    authHeaders.add(auth ?? '');
    if (auth != 'Bearer $accepted') {
      return ResponseBody.fromString(
        '{"code":"unauthorized","message":"no"}',
        401,
        headers: json,
      );
    }
    return ResponseBody.fromString('{"ok":true}', 200, headers: json);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('refreshes once and replays the request with the new token', () async {
    final server = _RefreshingServer(accepted: 'access-2');
    final storage = InMemoryTokenStorage(
      const StoredTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
    );
    var ended = false;
    final dio = ApiClientFactory.createDio(
      storage: storage,
      adapter: server,
      logRequests: false,
      onSessionEnded: () => ended = true,
    );

    final response = await dio.get<Map<String, Object?>>('/v1/me');

    expect(response.data, {'ok': true});
    expect(server.refreshCalls, 1);
    expect(server.authHeaders, ['Bearer access-1', 'Bearer access-2']);
    expect((await storage.read())?.refreshToken, 'refresh-2');
    expect(ended, isFalse);
  });

  test('a burst of failing requests shares one refresh', () async {
    final server = _RefreshingServer(accepted: 'access-2');
    final storage = InMemoryTokenStorage(
      const StoredTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
    );
    final dio = ApiClientFactory.createDio(
      storage: storage,
      adapter: server,
      logRequests: false,
      onSessionEnded: () {},
    );

    await Future.wait([
      dio.get<Object?>('/v1/me'),
      dio.get<Object?>('/v1/me'),
      dio.get<Object?>('/v1/me'),
    ]);

    expect(server.refreshCalls, 1);
  });

  test('ends the session when the refresh token is rejected', () async {
    final server = _RefreshingServer(accepted: 'access-2', refreshStatus: 401);
    final storage = InMemoryTokenStorage(
      const StoredTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
    );
    var ended = false;
    final dio = ApiClientFactory.createDio(
      storage: storage,
      adapter: server,
      logRequests: false,
      onSessionEnded: () => ended = true,
    );

    await expectLater(dio.get<Object?>('/v1/me'), throwsA(isA<DioException>()));

    expect(ended, isTrue);
    expect(await storage.read(), isNull);
    expect(server.refreshCalls, 1);
  });
}
