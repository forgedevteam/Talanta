import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talanta/core/storage/token_storage.dart';

import '../support/fake_api.dart';
import '../support/harness.dart';

const _tokens = StoredTokens(
  accessToken: 'access-0',
  refreshToken: 'refresh-0',
);

/// A signed-in account that has finished onboarding.
FakeApi member() => FakeApi()
  ..talents = [FakeApi.categories.first['id']!]
  ..dateOfBirth = '1998-03-14'
  ..profile = {
    'username': 'nkeng_sings',
    'displayName': 'Nkeng Ebai',
    'bio': null,
    'avatarUrl': null,
    'city': 'Douala',
    'isVerified': false,
  };

/// The request body as it goes over the wire.
Object? asJson(Object? body) => jsonDecode(jsonEncode(body));

Future<void> openTab(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(ValueKey(key)));
  await tester.pumpAndSettle();
}

void main() {
  group('Open Calls feed', () {
    testWidgets(
      'shows the featured row, the latest calls and one sponsored card',
      (
        tester,
      ) async {
        await pumpApp(tester, member(), tokens: _tokens);
        final l10n = l10nOf(tester);

        expect(find.text(l10n.callsFeatured), findsWidgets);
        expect(find.text('Danseurs pour un clip bikutsi'), findsOneWidget);
        expect(find.text('Singer for a wedding in Douala'), findsOneWidget);
        expect(find.textContaining('FCFA'), findsWidgets);
      },
    );

    testWidgets('filters by talent', (tester) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);

      await tester.tap(find.byKey(const ValueKey('filter-dance')));
      await tester.pumpAndSettle();

      final request = api.requests.lastWhere(
        (r) => r.path == '/v1/opportunities',
      );
      expect(request.query['category'], 'dance');
    });

    testWidgets('shows a sponsored card after the third call, labelled', (
      tester,
    ) async {
      final api = member();
      for (var i = 3; i < 6; i++) {
        final id = '01000000-0000-7000-8000-0000000c000$i';
        api.calls[id] = {
          ...api.calls[FakeApi.callId]!,
          'id': id,
          'title': 'Call number $i',
        };
      }
      await pumpApp(tester, api, tokens: _tokens);
      final l10n = l10nOf(tester);

      await tester.scrollUntilVisible(
        find.textContaining(l10n.callsSponsored),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Your first call is free'), findsOneWidget);
    });
  });

  group('a call', () {
    testWidgets('shows the safety notice and lets a member apply', (
      tester,
    ) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);
      final l10n = l10nOf(tester);

      await tester.tap(find.text('Singer for a wedding in Douala'));
      await tester.pumpAndSettle();
      expect(find.text(l10n.callSafety), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('apply')));
      await tester.pumpAndSettle();

      // Too short is caught before anything is sent.
      await tester.enterText(find.byKey(const ValueKey('apply-message')), 'Hi');
      await tester.tap(find.byKey(const ValueKey('send-application')));
      await tester.pumpAndSettle();
      expect(find.text(l10n.applyMessageTooShort), findsOneWidget);
      expect(api.applied, isEmpty);

      await tester.enterText(
        find.byKey(const ValueKey('apply-message')),
        'I sing makossa at weddings every month and I am free that weekend.',
      );
      await tester.tap(find.byKey(const ValueKey('send-application')));
      await tester.pumpAndSettle();

      expect(api.applied[FakeApi.callId], 'submitted');
      expect(find.byKey(const ValueKey('my-status')), findsOneWidget);
      expect(find.text(l10n.statusSubmitted), findsOneWidget);
    });

    testWidgets('lets anyone report it', (tester) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);
      final l10n = l10nOf(tester);

      await tester.tap(find.text('Singer for a wedding in Douala'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('report-call')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('report-scam')));
      await tester.pumpAndSettle();

      final report = api.requests.lastWhere((r) => r.path == '/v1/reports');
      expect(asJson(report.body), {
        'targetType': 'opportunity',
        'targetId': FakeApi.callId,
        'reason': 'scam',
      });
      expect(find.text(l10n.reportThanks), findsOneWidget);
    });
  });

  group('posting a call', () {
    testWidgets('checks the form, needs an amount for paid work, then publishes', (
      tester,
    ) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);
      final l10n = l10nOf(tester);

      await tester.tap(find.byKey(const ValueKey('post-call')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('publish-call')));
      await tester.pumpAndSettle();

      expect(find.text(l10n.postErrorTitle), findsOneWidget);
      expect(find.text(l10n.postErrorTalent), findsOneWidget);
      expect(
        api.requests.where(
          (r) => r.method == 'POST' && r.path == '/v1/opportunities',
        ),
        isEmpty,
      );

      await tester.enterText(
        find.byKey(const ValueKey('post-title')),
        'MC for a concert in Buea',
      );
      await tester.tap(find.byKey(const ValueKey('post-talent-music')));
      await tester.enterText(
        find.byKey(const ValueKey('post-description')),
        'Bilingual MC for a two-hour concert on Saturday night, sound provided.',
      );
      await tester.pump();
      await tester.ensureVisible(find.byKey(const ValueKey('publish-call')));
      await tester.tap(find.byKey(const ValueKey('publish-call')));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('post-amount')),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text(l10n.postErrorAmount), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('post-amount')),
        '75000',
      );
      await tester.tap(find.byKey(const ValueKey('publish-call')));
      await tester.pumpAndSettle();

      final sent = api.requests.lastWhere(
        (r) => r.method == 'POST' && r.path == '/v1/opportunities',
      );
      expect(asJson(sent.body), {
        'title': 'MC for a concert in Buea',
        'description':
            'Bilingual MC for a two-hour concert on Saturday night, sound provided.',
        'categoryId': FakeApi.categories.first['id'],
        'city': 'Douala',
        'compensation': 'paid',
        'budgetAmount': 75000,
      });
      // The new call opens with the poster's controls.
      expect(find.byKey(const ValueKey('view-applicants')), findsOneWidget);
    });
  });

  group('activity', () {
    testWidgets('writes notifications in plain words and marks them read', (
      tester,
    ) async {
      final api = member()
        ..unreadCount = 2
        ..notificationItems.addAll([
          {
            'id': '01000000-0000-7000-8000-0000000f0001',
            'type': 'application_status',
            'actor': FakeApi.person('brice_events', 'Brice Mbarga'),
            'opportunityId': FakeApi.callId,
            'opportunityTitle': 'Singer for a wedding in Douala',
            'applicationStatus': 'shortlisted',
            'isRead': false,
            'createdAt': '2026-11-18T09:00:00.000Z',
          },
          {
            'id': '01000000-0000-7000-8000-0000000f0002',
            'type': 'new_follower',
            'actor': FakeApi.person('awa_danse', 'Awa Ngono'),
            'opportunityId': null,
            'opportunityTitle': null,
            'applicationStatus': null,
            'isRead': false,
            'createdAt': '2026-11-18T09:00:00.000Z',
          },
        ]);
      await pumpApp(tester, api, tokens: _tokens);
      final l10n = l10nOf(tester);

      expect(find.text('2'), findsOneWidget);
      await openTab(tester, 'nav-activity');

      expect(
        find.text(l10n.notifShortlisted('Singer for a wedding in Douala')),
        findsOneWidget,
      );
      expect(find.text(l10n.notifNewFollower('Awa Ngono')), findsOneWidget);
      expect(
        api.requests.any((r) => r.path == '/v1/me/notifications/read-all'),
        isTrue,
      );
    });
  });

  group('discover and profile', () {
    testWidgets('lists creators', (tester) async {
      await pumpApp(tester, member(), tokens: _tokens);

      await openTab(tester, 'nav-discover');

      expect(find.byKey(const ValueKey('creator-awa_danse')), findsOneWidget);
    });

    testWidgets('adds work to the portfolio and refuses non-https links', (
      tester,
    ) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);
      final l10n = l10nOf(tester);
      await openTab(tester, 'nav-me');

      await tester.tap(find.byKey(const ValueKey('add-work')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('work-title')),
        'Live in Bonapriso',
      );
      await tester.enterText(
        find.byKey(const ValueKey('work-link')),
        'http://youtube.com/x',
      );
      await tester.tap(find.byKey(const ValueKey('save-work')));
      await tester.pumpAndSettle();
      expect(find.text(l10n.errorLinkNotAllowed), findsOneWidget);
      expect(api.portfolio, isEmpty);

      await tester.enterText(
        find.byKey(const ValueKey('work-link')),
        'https://www.youtube.com/watch?v=abc',
      );
      await tester.tap(find.byKey(const ValueKey('save-work')));
      await tester.pumpAndSettle();

      expect(api.portfolio.single['title'], 'Live in Bonapriso');
      expect(find.text('Live in Bonapriso'), findsOneWidget);
    });

    testWidgets('deletes the account after confirming', (tester) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);
      await openTab(tester, 'nav-me');

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('delete-account')),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.byKey(const ValueKey('delete-account')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('confirm-delete')));
      await tester.pumpAndSettle();

      expect(api.accountDeleted, isTrue);
      expect(find.byKey(const ValueKey('phone-field')), findsOneWidget);
    });
  });
}
