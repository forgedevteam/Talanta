import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:talanta/app/app.dart';
import 'package:talanta/core/network/api_client.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta/core/storage/token_storage.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';

import 'fake_api.dart';

/// A phone-sized viewport, so layouts are tested at the size they ship at.
Future<void> usePhoneViewport(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

List<Override> providerOverrides(FakeApi api, {StoredTokens? tokens}) {
  final storage = InMemoryTokenStorage(tokens);
  return [
    tokenStorageProvider.overrideWithValue(storage),
    dioProvider.overrideWith(
      (ref) => ApiClientFactory.createDio(
        storage: storage,
        adapter: api,
        logRequests: false,
        onSessionEnded: () => ref.read(sessionProvider.notifier).sessionEnded(),
      ),
    ),
  ];
}

/// The whole app over [api]. Starts signed out unless [tokens] are given.
Future<void> pumpApp(
  WidgetTester tester,
  FakeApi api, {
  StoredTokens? tokens,
}) async {
  await usePhoneViewport(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: providerOverrides(api, tokens: tokens),
      child: const TalantaApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// One screen inside a themed, localised app shell.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  FakeApi? api,
}) async {
  await usePhoneViewport(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: api == null ? const [] : providerOverrides(api),
      child: MaterialApp(
        theme: TalantaTheme.dark(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: screen,
      ),
    ),
  );
  await tester.pump();
}

/// Unmounts everything so pending timers in screens are cancelled.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
}

/// Pumps frames for [duration] without waiting for every timer to finish,
/// for screens with a live countdown that would keep pumpAndSettle busy.
Future<void> settle(
  WidgetTester tester, [
  Duration duration = const Duration(milliseconds: 800),
]) async {
  const step = Duration(milliseconds: 100);
  for (var elapsed = Duration.zero; elapsed < duration; elapsed += step) {
    await tester.pump(step);
  }
}

AppLocalizations l10nOf(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(Scaffold).first));
