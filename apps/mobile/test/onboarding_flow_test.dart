import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talanta/core/storage/token_storage.dart';
import 'package:talanta/features/onboarding/application/onboarding_controller.dart';

import 'support/fake_api.dart';
import 'support/harness.dart';

void main() {
  group('first launch', () {
    testWidgets(
      'goes from splash to the phone screen when no one is signed in',
      (tester) async {
        final api = FakeApi();
        await pumpApp(tester, api);

        expect(find.byKey(const ValueKey('phone-field')), findsOneWidget);
        expect(api.requests, isEmpty);
      },
    );

    testWidgets(
      'resumes a stored session and lands on the right onboarding step',
      (tester) async {
        final api = FakeApi()..talents = [FakeApi.categories.first['id']!];
        await pumpApp(
          tester,
          api,
          tokens: const StoredTokens(
            accessToken: 'access-0',
            refreshToken: 'refresh-0',
          ),
        );

        expect(api.requests.single.path, '/v1/me');
        expect(find.byKey(const ValueKey('name-field')), findsOneWidget);
      },
    );

    testWidgets('keeps a stored session when the server cannot be reached', (
      tester,
    ) async {
      final api = FakeApi()..talents = [FakeApi.categories.first['id']!];
      api.overrides['GET /v1/me'] = api.problem(503, 'service_unavailable');
      await usePhoneViewport(tester);
      await pumpApp(
        tester,
        api,
        tokens: const StoredTokens(accessToken: 'a', refreshToken: 'r'),
      );
      // Let the network retries run out.
      await settle(tester, const Duration(seconds: 3));

      expect(find.byKey(const ValueKey('splash-offline')), findsOneWidget);
      expect(find.byKey(const ValueKey('phone-field')), findsNothing);

      api.overrides.remove('GET /v1/me');
      await tester.tap(find.byKey(const ValueKey('splash-retry')));
      await settle(tester, const Duration(seconds: 2));

      expect(find.byKey(const ValueKey('name-field')), findsOneWidget);
    });

    testWidgets('clears a dead session and shows the phone screen', (
      tester,
    ) async {
      final api = FakeApi();
      api.overrides['GET /v1/me'] = api.problem(401, 'unauthorized');
      await pumpApp(
        tester,
        api,
        tokens: const StoredTokens(accessToken: 'stale', refreshToken: 'stale'),
      );

      expect(find.byKey(const ValueKey('phone-field')), findsOneWidget);
    });
  });

  testWidgets(
    'a new person signs in, picks talents, creates a profile and reaches home',
    (tester) async {
      final api = FakeApi();
      await pumpApp(tester, api);
      final l10n = l10nOf(tester);

      // Phone number.
      await tester.enterText(
        find.byKey(const ValueKey('phone-field')),
        '6 71 23 45 67',
      );
      await tester.tap(find.byKey(const ValueKey('send-code')));
      await settle(tester);

      expect(api.requests.last.path, '/v1/auth/otp/request');
      expect(api.requests.last.body, {
        'phone': '6 71 23 45 67',
        'country': 'CM',
      });
      expect(
        find.text(l10n.otpSubtitle(FakeApi.displayPhone.replaceAll(' ', ' '))),
        findsOneWidget,
      );

      // Code: a wrong one first.
      await tester.enterText(find.byKey(const ValueKey('otp-field')), '000000');
      await settle(tester);
      expect(find.byKey(const ValueKey('otp-error')), findsOneWidget);
      expect(find.text(l10n.otpErrorInvalid), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('otp-field')),
        FakeApi.validCode,
      );
      await tester.pumpAndSettle();

      // Talents.
      expect(find.byKey(const ValueKey('talents-grid')), findsOneWidget);
      expect(find.text(l10n.talentsSelectedCount(0)), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('talent-dance')));
      await tester.tap(find.byKey(const ValueKey('talent-music')));
      await tester.pumpAndSettle();
      expect(find.text(l10n.talentsSelectedCount(2)), findsOneWidget);
      expect(find.text(l10n.talentsMain), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('save-talents')));
      await tester.pumpAndSettle();

      expect(api.requests.last.path, '/v1/me/talents');
      expect(api.requests.last.body, {
        'categoryIds': [
          FakeApi.categories[1]['id'],
          FakeApi.categories[0]['id'],
        ],
      });

      // Profile.
      expect(find.byKey(const ValueKey('name-field')), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('name-field')),
        'Amara Okafor',
      );
      await tester.enterText(
        find.byKey(const ValueKey('username-field')),
        'Amara_Sings',
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(
        find.text(l10n.profileUsernameAvailable('amara_sings')),
        findsOneWidget,
      );

      await tester.enterText(find.byKey(const ValueKey('city-field')), 'Lagos');
      await pickSuggestedBirthday(tester);
      await tester.tap(find.byKey(const ValueKey('finish-profile')));
      await tester.pumpAndSettle();

      final now = clock.now();
      expect(api.requests.last.path, '/v1/me/profile');
      expect(api.requests.last.body, {
        'displayName': 'Amara Okafor',
        'username': 'amara_sings',
        'city': 'Lagos',
        'dateOfBirth': isoDate(DateTime(now.year - 18, now.month, now.day)),
      });

      // Home.
      expect(find.text(l10n.homeWelcome('Amara Okafor')), findsOneWidget);
      expect(find.text('Dance'), findsOneWidget);

      // Sign out returns to the phone screen.
      await tester.tap(find.byKey(const ValueKey('sign-out')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('phone-field')), findsOneWidget);
      expect(api.requests.last.path, '/v1/auth/logout');
    },
  );
}
