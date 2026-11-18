// End-to-end check of sign-in and onboarding: the real app, on a device or
// emulator, against a running API. Nothing is faked.
//
//   pnpm dev:db && pnpm dev:api            (API with OTP_DEV_FIXED_CODE set)
//   adb reverse tcp:3000 tcp:3000
//   flutter test integration_test -d <device> --dart-define=OTP_CODE=<code>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:talanta/app/app.dart';
import 'package:talanta/core/storage/token_storage.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';

const otpCode = String.fromEnvironment('OTP_CODE', defaultValue: '246810');

/// Pumps until [finder] matches, for screens that wait on the network.
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out waiting for $finder');
}

Future<void> chooseBirthYear(WidgetTester tester, String year) async {
  final field = find.byKey(const ValueKey('dob-field'));
  await tester.ensureVisible(field);
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    find.text(year),
    -150,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.tap(find.text(year));
  await tester.pumpAndSettle();
  await tester.tap(
    find.text(
      MaterialLocalizations.of(
        tester.element(find.byType(Scaffold).first),
      ).okButtonLabel,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a new person signs up, onboards and signs out', (tester) async {
    await SecureTokenStorage().clear();
    // A new number each run, so the account is new and no rate limit is hit.
    final suffix = (DateTime.now().millisecondsSinceEpoch % 10000000)
        .toString()
        .padLeft(7, '0');
    final phone = '67$suffix';
    final username = 'e2e_$suffix';

    await tester.pumpWidget(const ProviderScope(child: TalantaApp()));
    await waitFor(tester, find.byKey(const ValueKey('phone-field')));
    final l10n = AppLocalizations.of(
      tester.element(find.byType(Scaffold).first),
    );

    // Phone number.
    await tester.enterText(find.byKey(const ValueKey('phone-field')), phone);
    await tester.tap(find.byKey(const ValueKey('send-code')));
    await waitFor(tester, find.byKey(const ValueKey('otp-field')));
    expect(find.textContaining('+237 6 7'), findsOneWidget);

    // A wrong code, then the right one.
    const wrong = otpCode == '000000' ? '111111' : '000000';
    await tester.enterText(find.byKey(const ValueKey('otp-field')), wrong);
    await waitFor(tester, find.text(l10n.otpErrorInvalid));
    await tester.enterText(find.byKey(const ValueKey('otp-field')), otpCode);
    await waitFor(tester, find.byKey(const ValueKey('talents-grid')));

    // Talents.
    await waitFor(tester, find.byKey(const ValueKey('talent-dance')));
    await tester.tap(find.byKey(const ValueKey('talent-dance')));
    await tester.tap(find.byKey(const ValueKey('talent-music')));
    await tester.pump();
    expect(find.text(l10n.talentsSelectedCount(2)), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('save-talents')));
    await waitFor(tester, find.byKey(const ValueKey('name-field')));

    // Profile, with a live username check.
    await tester.enterText(
      find.byKey(const ValueKey('name-field')),
      'Amara Okafor',
    );
    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      username,
    );
    await waitFor(tester, find.text(l10n.profileUsernameAvailable(username)));
    await tester.enterText(find.byKey(const ValueKey('city-field')), 'Lagos');

    // Too young first: the server refuses and nothing is saved.
    final tooYoungYear = (DateTime.now().year - 11).toString();
    await chooseBirthYear(tester, tooYoungYear);
    await tester.tap(find.byKey(const ValueKey('finish-profile')));
    await waitFor(tester, find.text(l10n.profileErrorTooYoung));

    // Then an adult date of birth.
    await chooseBirthYear(tester, (DateTime.now().year - 25).toString());
    await tester.tap(find.byKey(const ValueKey('finish-profile')));
    await waitFor(tester, find.byKey(const ValueKey('home-welcome')));

    expect(find.text(l10n.homeWelcome('Amara Okafor')), findsOneWidget);
    expect(find.text('@$username · Lagos'), findsOneWidget);
    expect(find.text('Dance'), findsOneWidget);
    expect(find.text('Music'), findsOneWidget);

    // Sign out.
    await tester.tap(find.byKey(const ValueKey('sign-out')));
    await waitFor(tester, find.byKey(const ValueKey('phone-field')));
    expect(await SecureTokenStorage().read(), isNull);
  });
}
