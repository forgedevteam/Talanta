import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talanta/features/auth/presentation/phone_screen.dart';

import '../../support/fake_api.dart';
import '../../support/harness.dart';

void main() {
  testWidgets('shows the question, Cameroon by default and the legal line', (
    tester,
  ) async {
    await pumpScreen(tester, const PhoneScreen(), api: FakeApi());
    final l10n = l10nOf(tester);

    expect(find.text(l10n.phoneTitle), findsOneWidget);
    expect(find.text('+237'), findsOneWidget);
    expect(find.text(l10n.phoneLegal), findsOneWidget);
  });

  testWidgets('refuses an obviously short number without calling the API', (
    tester,
  ) async {
    final api = FakeApi();
    await pumpScreen(tester, const PhoneScreen(), api: api);
    final l10n = l10nOf(tester);

    await tester.enterText(find.byKey(const ValueKey('phone-field')), '671');
    await tester.tap(find.byKey(const ValueKey('send-code')));
    await tester.pumpAndSettle();

    expect(find.text(l10n.phoneErrorInvalid), findsOneWidget);
    expect(api.requests, isEmpty);
  });

  testWidgets('lets the person switch country from the picker', (tester) async {
    final api = FakeApi();
    await pumpApp(tester, api);

    await tester.tap(find.byKey(const ValueKey('country-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('country-KE')));
    await tester.pumpAndSettle();

    expect(find.text('+254'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('phone-field')),
      '0712 345 678',
    );
    await tester.tap(find.byKey(const ValueKey('send-code')));
    await tester.pumpAndSettle();

    expect(api.requests.single.body, {
      'phone': '0712 345 678',
      'country': 'KE',
    });
  });

  testWidgets('shows the server’s reason when the number is rejected', (
    tester,
  ) async {
    final api = FakeApi();
    api.overrides['POST /v1/auth/otp/request'] = api.problem(
      422,
      'phone_country_unsupported',
    );
    await pumpScreen(tester, const PhoneScreen(), api: api);
    final l10n = l10nOf(tester);

    await tester.enterText(
      find.byKey(const ValueKey('phone-field')),
      '+44 7400 123456',
    );
    await tester.tap(find.byKey(const ValueKey('send-code')));
    await tester.pumpAndSettle();

    expect(find.text(l10n.phoneErrorCountryUnsupported), findsOneWidget);
  });

  testWidgets('tells the person to wait when they ask for codes too quickly', (
    tester,
  ) async {
    final api = FakeApi();
    api.overrides['POST /v1/auth/otp/request'] = api.problem(
      429,
      'otp_resend_too_soon',
    );
    await pumpScreen(tester, const PhoneScreen(), api: api);
    final l10n = l10nOf(tester);

    await tester.enterText(
      find.byKey(const ValueKey('phone-field')),
      '6 71 23 45 67',
    );
    await tester.tap(find.byKey(const ValueKey('send-code')));
    await tester.pumpAndSettle();

    expect(find.text(l10n.otpErrorResendTooSoon), findsOneWidget);
  });

  testWidgets('speaks French on a phone set to French', (tester) async {
    await pumpScreen(
      tester,
      const PhoneScreen(),
      api: FakeApi(),
      locale: const Locale('fr'),
    );

    expect(find.text('Quel est ton numéro ?'), findsOneWidget);
    expect(find.text('Recevoir un code'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('country-button')));
    await tester.pumpAndSettle();
    expect(find.text('Cameroun'), findsOneWidget);
    expect(find.text('Afrique du Sud'), findsOneWidget);
  });
}
