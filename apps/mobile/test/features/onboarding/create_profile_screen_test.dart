import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talanta/core/storage/token_storage.dart';

import '../../support/fake_api.dart';
import '../../support/harness.dart';

const _tokens = StoredTokens(
  accessToken: 'access-0',
  refreshToken: 'refresh-0',
);

FakeApi apiAtProfileStep() =>
    FakeApi()..talents = [FakeApi.categories.first['id']!];

void main() {
  testWidgets('explains every empty field at once', (tester) async {
    final api = apiAtProfileStep();
    await pumpApp(tester, api, tokens: _tokens);
    final l10n = l10nOf(tester);

    await tester.tap(find.byKey(const ValueKey('finish-profile')));
    await tester.pumpAndSettle();

    expect(find.text(l10n.profileErrorNameLength), findsOneWidget);
    expect(find.text(l10n.profileErrorUsernameFormat), findsOneWidget);
    expect(find.text(l10n.profileErrorCity), findsOneWidget);
    expect(api.requests.where((r) => r.path == '/v1/me/profile'), isEmpty);
  });

  testWidgets('lower-cases the username and checks it live', (tester) async {
    final api = apiAtProfileStep();
    await pumpApp(tester, api, tokens: _tokens);
    final l10n = l10nOf(tester);

    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'Taken',
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('taken'), findsOneWidget);
    expect(find.text(l10n.profileUsernameTaken), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'admin',
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text(l10n.profileUsernameReserved), findsOneWidget);
  });

  testWidgets('shows a clash reported on save under the username field', (
    tester,
  ) async {
    final api = apiAtProfileStep();
    api.overrides['GET /v1/profiles/username-availability'] =
        const FakeResponse(200, {'username': 'taken', 'status': 'available'});
    await pumpApp(tester, api, tokens: _tokens);
    final l10n = l10nOf(tester);

    await tester.enterText(find.byKey(const ValueKey('name-field')), 'Thandi');
    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'taken',
    );
    await tester.enterText(find.byKey(const ValueKey('city-field')), 'Durban');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const ValueKey('finish-profile')));
    await tester.pumpAndSettle();

    expect(find.text(l10n.profileUsernameTaken), findsOneWidget);
    expect(find.byKey(const ValueKey('name-field')), findsOneWidget);
  });

  testWidgets('shows server-side field messages', (tester) async {
    final api = apiAtProfileStep();
    api.overrides['PUT /v1/me/profile'] = api.problem(
      422,
      'validation_failed',
      fields: {
        'city': ['Tell us the city you create from.'],
      },
    );
    await pumpApp(tester, api, tokens: _tokens);

    await tester.enterText(find.byKey(const ValueKey('name-field')), 'Thandi');
    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'thandi',
    );
    await tester.enterText(find.byKey(const ValueKey('city-field')), 'Du');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const ValueKey('finish-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Tell us the city you create from.'), findsOneWidget);
  });

  testWidgets('pre-fills an existing profile for editing', (tester) async {
    final api = apiAtProfileStep();
    await pumpApp(tester, api, tokens: _tokens);

    await tester.enterText(find.byKey(const ValueKey('name-field')), 'Wanjiru');
    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'wanjiru',
    );
    await tester.enterText(find.byKey(const ValueKey('city-field')), 'Nairobi');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const ValueKey('finish-profile')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home-welcome')), findsOneWidget);
    expect(api.profile?['displayName'], 'Wanjiru');
  });
}
