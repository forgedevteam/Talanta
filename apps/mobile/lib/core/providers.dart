import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_client.dart';
import 'package:talanta/core/storage/token_storage.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta_api/talanta_api.dart';

/// App-wide wiring. Tests override [tokenStorageProvider] and [dioProvider].
final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => SecureTokenStorage(),
);

final dioProvider = Provider<Dio>((ref) {
  return ApiClientFactory.createDio(
    storage: ref.watch(tokenStorageProvider),
    onSessionEnded: () => ref.read(sessionProvider.notifier).sessionEnded(),
  );
});

final apiProvider = Provider<TalantaApi>(
  (ref) => ApiClientFactory.createApi(ref.watch(dioProvider)),
);
