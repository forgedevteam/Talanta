import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talanta/core/storage/token_storage.dart';

import '../../support/fake_api.dart';
import '../../support/harness.dart';

const _tokens = StoredTokens(
  accessToken: 'access-0',
  refreshToken: 'refresh-0',
);

void main() {
  testWidgets('lists the categories and needs one pick before continuing', (
    tester,
  ) async {
    final api = FakeApi();
    await pumpApp(tester, api, tokens: _tokens);
    final l10n = l10nOf(tester);

    for (final category in FakeApi.categories) {
      expect(find.text(category['name']!), findsOneWidget);
    }
    final button = tester.widget<FilledButton>(
      find.descendant(
        of: find.byKey(const ValueKey('save-talents')),
        matching: find.byType(FilledButton),
      ),
    );
    expect(button.onPressed, isNull);
    expect(find.text(l10n.talentsSelectedCount(0)), findsOneWidget);
  });

  testWidgets('caps picks at five', (tester) async {
    final api = FakeApi();
    await pumpApp(tester, api, tokens: _tokens);
    final l10n = l10nOf(tester);

    for (final category in FakeApi.categories) {
      await tester.tap(find.byKey(ValueKey('talent-${category['slug']}')));
      await tester.pump();
    }

    expect(find.text(l10n.talentsSelectedCount(5)), findsOneWidget);
  });

  testWidgets(
    'tapping again removes a pick and the star promotes a main talent',
    (tester) async {
      final api = FakeApi();
      await pumpApp(tester, api, tokens: _tokens);

      await tester.tap(find.byKey(const ValueKey('talent-music')));
      await tester.tap(find.byKey(const ValueKey('talent-dance')));
      await tester.tap(find.byKey(const ValueKey('talent-art')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('talent-music')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('make-main-art')));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey('save-talents')));
      await tester.pumpAndSettle();

      expect(api.requests.last.body, {
        'categoryIds': [
          FakeApi.categories[4]['id'],
          FakeApi.categories[1]['id'],
        ],
      });
    },
  );

  testWidgets('offers a retry when the list cannot load', (tester) async {
    final api = FakeApi();
    api.overrides['GET /v1/talent-categories'] = api.problem(
      503,
      'service_unavailable',
    );
    await pumpApp(tester, api, tokens: _tokens);
    final l10n = l10nOf(tester);

    expect(find.text(l10n.errorServer), findsOneWidget);

    api.overrides.remove('GET /v1/talent-categories');
    await tester.tap(find.text(l10n.retry));
    await tester.pumpAndSettle();

    expect(find.text('Music'), findsOneWidget);
  });

  testWidgets('skips onboarding for an account that has finished it', (
    tester,
  ) async {
    final api = FakeApi()
      ..talents = [FakeApi.categories[2]['id']!]
      ..profile = {
        'username': 'kwame',
        'displayName': 'Kwame',
        'bio': null,
        'avatarUrl': null,
        'city': 'Accra',
        'isVerified': false,
      };
    await pumpApp(tester, api, tokens: _tokens);
    final l10n = l10nOf(tester);
    expect(find.text(l10n.homeWelcome('Kwame')), findsOneWidget);
  });
}
