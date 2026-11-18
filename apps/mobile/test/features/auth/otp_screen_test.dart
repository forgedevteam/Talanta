import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_api.dart';
import '../../support/harness.dart';

Future<void> reachOtpScreen(WidgetTester tester, FakeApi api) async {
  await pumpApp(tester, api);
  await tester.enterText(
    find.byKey(const ValueKey('phone-field')),
    '0803 123 4567',
  );
  await tester.tap(find.byKey(const ValueKey('send-code')));
  await settle(tester);
}

void main() {
  testWidgets('shows six boxes, the number, and a resend countdown', (
    tester,
  ) async {
    final api = FakeApi();
    await reachOtpScreen(tester, api);
    final l10n = l10nOf(tester);

    expect(find.text(l10n.otpSubtitle(FakeApi.phoneE164)), findsOneWidget);
    expect(find.text(l10n.otpResendIn(60)), findsOneWidget);
    expect(find.text(l10n.otpResend), findsNothing);

    await tester.pump(const Duration(seconds: 61));
    expect(find.text(l10n.otpResend), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('verifies as soon as the sixth digit is typed', (tester) async {
    final api = FakeApi();
    await reachOtpScreen(tester, api);

    await tester.enterText(find.byKey(const ValueKey('otp-field')), '24681');
    await tester.pump();
    expect(api.requests.where((r) => r.path == '/v1/auth/otp/verify'), isEmpty);

    await tester.enterText(
      find.byKey(const ValueKey('otp-field')),
      FakeApi.validCode,
    );
    await tester.pumpAndSettle();

    final verify = api.requests.lastWhere(
      (r) => r.path == '/v1/auth/otp/verify',
    );
    expect(verify.body, {
      'phone': FakeApi.phoneE164,
      'code': FakeApi.validCode,
    });
    expect(find.byKey(const ValueKey('talents-grid')), findsOneWidget);
  });

  testWidgets('clears the boxes and explains a wrong code', (tester) async {
    final api = FakeApi();
    await reachOtpScreen(tester, api);
    final l10n = l10nOf(tester);

    await tester.enterText(find.byKey(const ValueKey('otp-field')), '111111');
    await settle(tester);

    expect(find.text(l10n.otpErrorInvalid), findsOneWidget);
    expect(find.text('1'), findsNothing);
    await unmount(tester);
  });

  testWidgets('explains a burnt code after too many tries', (tester) async {
    final api = FakeApi();
    api.overrides['POST /v1/auth/otp/verify'] = api.problem(
      429,
      'otp_too_many_attempts',
    );
    await reachOtpScreen(tester, api);
    final l10n = l10nOf(tester);

    await tester.enterText(find.byKey(const ValueKey('otp-field')), '111111');
    await settle(tester);

    expect(find.text(l10n.otpErrorTooManyAttempts), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('resends after the countdown and restarts it', (tester) async {
    final api = FakeApi();
    await reachOtpScreen(tester, api);
    final l10n = l10nOf(tester);

    await tester.pump(const Duration(seconds: 61));
    await tester.tap(find.byKey(const ValueKey('resend-code')));
    await settle(tester);

    expect(
      api.requests.where((r) => r.path == '/v1/auth/otp/request'),
      hasLength(2),
    );
    expect(find.text(l10n.otpSent), findsOneWidget);
    expect(find.text(l10n.otpResendIn(60)), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('goes back to the phone screen to change the number', (
    tester,
  ) async {
    final api = FakeApi();
    await reachOtpScreen(tester, api);

    await tester.tap(find.byKey(const ValueKey('change-number')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('phone-field')), findsOneWidget);
    // The number typed earlier is still there.
    final field = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const ValueKey('phone-field')),
        matching: find.byType(TextField),
      ),
    );
    expect(field.controller?.text, '0803 123 4567');
  });
}
