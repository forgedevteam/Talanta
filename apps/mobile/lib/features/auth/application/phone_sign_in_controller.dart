import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/auth/domain/country.dart';
import 'package:talanta_api/talanta_api.dart';

/// The phone number a code was sent to and when it may be resent.
class PendingOtp {
  const PendingOtp({
    required this.country,
    required this.typedPhone,
    required this.phoneE164,
    required this.displayPhone,
    required this.resendAt,
    required this.expiresAt,
  });

  final Country country;
  final String typedPhone;
  final String phoneE164;

  /// Grouped for reading, as the server formats it for the country.
  final String displayPhone;
  final DateTime resendAt;
  final DateTime expiresAt;
}

/// Drives the phone and code screens. Holds the number between them.
class PhoneSignInController extends Notifier<PendingOtp?> {
  @override
  PendingOtp? build() => null;

  TalantaApi get _api => ref.read(apiProvider);

  /// Sends a code. Throws an [ApiFailure] the screen can show.
  Future<PendingOtp> requestCode({
    required Country country,
    required String phone,
  }) async {
    try {
      final challenge = await _api.auth.requestOtp(
        body: RequestOtp(phone: phone, country: country.code),
      );
      final now = clock.now();
      final pending = PendingOtp(
        country: country,
        typedPhone: phone,
        phoneE164: challenge.phone,
        displayPhone: challenge.displayPhone,
        resendAt: now.add(
          Duration(seconds: challenge.resendAfterSeconds.toInt()),
        ),
        expiresAt: now.add(
          Duration(seconds: challenge.expiresInSeconds.toInt()),
        ),
      );
      state = pending;
      return pending;
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  Future<PendingOtp> resendCode() {
    final pending = state;
    if (pending == null) throw StateError('No code has been requested');
    return requestCode(country: pending.country, phone: pending.typedPhone);
  }

  /// Verifies the code and signs the person in. Throws an [ApiFailure].
  Future<AuthSession> verifyCode(String code) async {
    final pending = state;
    if (pending == null) throw StateError('No code has been requested');
    try {
      final session = await _api.auth.verifyOtp(
        body: VerifyOtp(phone: pending.phoneE164, code: code),
      );
      await ref.read(sessionProvider.notifier).signIn(session);
      state = null;
      return session;
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  void reset() => state = null;
}

final phoneSignInProvider =
    NotifierProvider<PhoneSignInController, PendingOtp?>(
      PhoneSignInController.new,
    );
