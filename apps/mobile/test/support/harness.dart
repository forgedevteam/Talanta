import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:talanta/app/app.dart';
import 'package:talanta/core/media/media.dart';
import 'package:talanta/core/network/api_client.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta/core/storage/token_storage.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/posts/application/post_actions.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';

import 'fake_api.dart';

/// A phone-sized viewport, so layouts are tested at the size they ship at.
Future<void> usePhoneViewport(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// A 1×1 transparent PNG.
final _transparentPng = Uint8List.fromList(const [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

List<Override> providerOverrides(FakeApi api, {StoredTokens? tokens}) {
  final storage = InMemoryTokenStorage(tokens);
  return [
    tokenStorageProvider.overrideWithValue(storage),
    // Real image loading needs a disk cache plugin; tests draw a blank.
    networkImageProvider.overrideWithValue((_) => MemoryImage(_transparentPng)),
    shareLauncherProvider.overrideWithValue((_) async {}),
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
  Locale? locale,
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
        locale: locale,
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

/// Opens the date-of-birth picker and accepts its suggestion (18 years ago).
Future<void> pickSuggestedBirthday(WidgetTester tester) async {
  final field = find.byKey(const ValueKey('dob-field'));
  await tester.ensureVisible(field);
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

AppLocalizations l10nOf(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(Scaffold).first));
