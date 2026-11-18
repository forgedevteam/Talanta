// Walks through every onboarding screen against a running API and saves a
// screenshot of each state, for design review and store listings.
//
//   flutter drive --driver=test_driver/integration_test.dart \
//     --target=integration_test/walkthrough_test.dart -d <device> \
//     --dart-define=OTP_CODE=<code> [--dart-define=LOCALE=fr]
//
// Screenshots land in build/screenshots/.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:talanta/app/app.dart';
import 'package:talanta/core/storage/token_storage.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';

import 'onboarding_e2e_test.dart'
    show chooseBirthYear, otpCode, signOutFromProfile, waitFor;

/// Test accounts from `db:seed-demo`, signed in with OTP_TEST_CODE.
const testCode = String.fromEnvironment('TEST_CODE', defaultValue: '123456');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding walkthrough', (tester) async {
    await SecureTokenStorage().clear();
    final suffix = (DateTime.now().millisecondsSinceEpoch % 10000000)
        .toString()
        .padLeft(7, '0');
    var shot = 0;
    Future<void> capture(String name) async {
      await tester.pump(const Duration(milliseconds: 400));
      shot += 1;
      await binding.takeScreenshot('${shot.toString().padLeft(2, '0')}-$name');
    }

    await binding.convertFlutterSurfaceToImage();
    const language = String.fromEnvironment('LOCALE');
    await tester.pumpWidget(
      ProviderScope(
        child: TalantaApp(
          locale: language.isEmpty ? null : Locale(language),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await capture('splash');

    await waitFor(tester, find.byKey(const ValueKey('phone-field')));
    final context = tester.element(find.byType(Scaffold).first);
    final l10n = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    await capture('phone-empty');

    await tester.tap(find.byKey(const ValueKey('country-button')));
    await tester.pumpAndSettle();
    await capture('country-picker');
    await tester.tap(find.byKey(const ValueKey('country-CM')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('send-code')));
    await tester.pumpAndSettle();
    await capture('phone-too-short');

    await tester.enterText(
      find.byKey(const ValueKey('phone-field')),
      '6 7$suffix',
    );
    await tester.pump();
    await capture('phone-filled');

    await tester.tap(find.byKey(const ValueKey('send-code')));
    await waitFor(tester, find.byKey(const ValueKey('otp-field')));
    await capture('code-empty');

    await tester.enterText(find.byKey(const ValueKey('otp-field')), '000000');
    await waitFor(tester, find.byKey(const ValueKey('otp-error')));
    await capture('code-wrong');

    await tester.enterText(find.byKey(const ValueKey('otp-field')), otpCode);
    await waitFor(tester, find.byKey(const ValueKey('talent-music')));
    await capture('talents-empty');

    await tester.tap(find.byKey(const ValueKey('talent-music')));
    await tester.tap(find.byKey(const ValueKey('talent-comedy')));
    await tester.tap(find.byKey(const ValueKey('talent-acting')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('make-main-comedy')));
    await tester.pump();
    await capture('talents-picked');

    await tester.tap(find.byKey(const ValueKey('save-talents')));
    await waitFor(tester, find.byKey(const ValueKey('name-field')));
    await capture('profile-empty');

    await tester.tap(find.byKey(const ValueKey('finish-profile')));
    await tester.pumpAndSettle();
    await capture('profile-errors');

    await tester.enterText(
      find.byKey(const ValueKey('name-field')),
      'Nkeng Ebai',
    );
    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'talanta',
    );
    await tester.pump(const Duration(seconds: 2));
    await capture('username-reserved');

    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'nkeng_$suffix',
    );
    await tester.enterText(find.byKey(const ValueKey('city-field')), 'Douala');
    await tester.pump(const Duration(seconds: 2));
    await capture('profile-filled');

    final dob = find.byKey(const ValueKey('dob-field'));
    await tester.ensureVisible(dob);
    await tester.tap(dob);
    await tester.pumpAndSettle();
    await capture('date-picker');
    await tester.tap(find.text(material.cancelButtonLabel));
    await tester.pumpAndSettle();

    await chooseBirthYear(tester, (DateTime.now().year - 11).toString());
    await tester.tap(find.byKey(const ValueKey('finish-profile')));
    await waitFor(tester, find.text(l10n.profileErrorTooYoung));
    await capture('too-young');

    await chooseBirthYear(tester, (DateTime.now().year - 24).toString());
    await tester.tap(find.byKey(const ValueKey('finish-profile')));
    await waitFor(tester, find.byKey(const ValueKey('calls-screen')));
    await capture('calls-new-member');
    await signOutFromProfile(tester);

    // ---- The demo talent: applications, notifications, follows. ----
    Future<void> signInAs(String number) async {
      await tester.enterText(find.byKey(const ValueKey('phone-field')), number);
      await tester.tap(find.byKey(const ValueKey('send-code')));
      await waitFor(tester, find.byKey(const ValueKey('otp-field')));
      await tester.enterText(find.byKey(const ValueKey('otp-field')), testCode);
      await waitFor(tester, find.byKey(const ValueKey('calls-screen')));
      await tester.pump(const Duration(seconds: 2));
    }

    await signInAs('6 99 00 00 01');
    await capture('calls-feed');
    await tester.scrollUntilVisible(
      find.textContaining(l10n.callsSponsored),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await capture('calls-sponsored');
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, 3000),
      4000,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('mariage').first);
    await waitFor(tester, find.text(l10n.callSafety));
    await capture('call-applied');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('nav-activity')));
    await waitFor(tester, find.byKey(const ValueKey('activity-screen')));
    await tester.pump(const Duration(seconds: 2));
    await capture('activity-notifications');
    await tester.tap(find.byKey(const ValueKey('tab-applications')));
    await tester.pump(const Duration(seconds: 2));
    await capture('activity-applications');

    await tester.tap(find.byKey(const ValueKey('nav-discover')));
    await waitFor(tester, find.byKey(const ValueKey('discover-search')));
    await tester.pump(const Duration(seconds: 2));
    await capture('discover');
    await tester.enterText(
      find.byKey(const ValueKey('discover-search')),
      'Awa',
    );
    await waitFor(tester, find.byKey(const ValueKey('creator-awa_danse')));
    await capture('discover-search');
    await tester.tap(find.byKey(const ValueKey('creator-awa_danse')));
    await waitFor(tester, find.byKey(const ValueKey('follow-button')));
    await capture('creator-profile');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tab-following')));
    await tester.pump(const Duration(seconds: 2));
    await capture('following');

    await tester.tap(find.byKey(const ValueKey('nav-me')));
    await waitFor(tester, find.byKey(const ValueKey('add-work')));
    await capture('my-profile');
    await tester.tap(find.byKey(const ValueKey('add-work')));
    await tester.pumpAndSettle();
    await capture('add-work');
    Navigator.of(
      tester.element(find.byKey(const ValueKey('work-title'))),
    ).pop();
    await tester.pumpAndSettle();
    await signOutFromProfile(tester);

    // ---- The demo organiser: posting and reviewing applicants. ----
    await signInAs('6 99 00 00 02');
    await tester.tap(find.byKey(const ValueKey('post-call')));
    await tester.pumpAndSettle();
    await capture('post-call');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-me')));
    await waitFor(tester, find.byKey(const ValueKey('menu-my-calls')));
    await tester.tap(find.byKey(const ValueKey('menu-my-calls')));
    await waitFor(tester, find.textContaining('FCFA'));
    await capture('my-calls');
    await tester.scrollUntilVisible(
      find.textContaining('mariage'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.textContaining('mariage').first);
    await waitFor(tester, find.byKey(const ValueKey('view-applicants')));
    await tester.tap(find.byKey(const ValueKey('view-applicants')));
    await waitFor(tester, find.textContaining('Nkeng'));
    await capture('applicants');
  });
}
