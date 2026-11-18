import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta/core/storage/token_storage.dart';
import 'package:talanta_api/talanta_api.dart';

/// Who is signed in, as far as the app knows.
sealed class SessionState {
  const SessionState();
}

/// Tokens are being checked. Shown as the splash screen.
final class SessionUnknown extends SessionState {
  const SessionUnknown();
}

/// A session is stored but the server could not be reached to confirm it.
final class SessionUnreachable extends SessionState {
  const SessionUnreachable();
}

final class SignedOut extends SessionState {
  const SignedOut();
}

final class SignedIn extends SessionState {
  const SignedIn(this.me);

  final Me me;
}

/// Owns the session. Everything that changes `me` goes through here so the
/// router always sees one source of truth.
class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() {
    unawaited(Future<void>.microtask(_bootstrap));
    return const SessionUnknown();
  }

  TokenStorage get _storage => ref.read(tokenStorageProvider);
  TalantaApi get _api => ref.read(apiProvider);

  Future<void> _bootstrap() async {
    final tokens = await _storage.read();
    if (tokens == null) {
      state = const SignedOut();
      return;
    }
    try {
      state = SignedIn(await _api.me.getMe());
    } on Object catch (error) {
      final failure = ApiFailure.from(error);
      if (failure is ProblemFailure &&
          (failure.status == 401 || failure.status == 403)) {
        await _storage.clear();
        state = const SignedOut();
      } else {
        // Keep the tokens: the session is probably fine, the network is not.
        state = const SessionUnreachable();
      }
    }
  }

  /// Tries again after [SessionUnreachable].
  Future<void> retry() async {
    state = const SessionUnknown();
    await _bootstrap();
  }

  Future<void> signIn(AuthSession session) async {
    await _storage.write(
      StoredTokens(
        accessToken: session.tokens.accessToken,
        refreshToken: session.tokens.refreshToken,
      ),
    );
    state = SignedIn(session.me);
  }

  /// Called with the `Me` returned by any endpoint that changed the account.
  void updateMe(Me me) {
    state = SignedIn(me);
  }

  Future<void> signOut() async {
    final tokens = await _storage.read();
    await _storage.clear();
    state = const SignedOut();
    if (tokens != null) {
      try {
        await _api.auth.signOut(
          body: RefreshToken(refreshToken: tokens.refreshToken),
        );
      } on Object catch (error) {
        // The device is signed out either way; the server copy expires on its own.
        debugPrint('Sign-out request failed: $error');
      }
    }
  }

  /// The refresh token was rejected: the server ended the session.
  void sessionEnded() {
    state = const SignedOut();
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);
