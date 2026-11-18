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

FakeApi member() => FakeApi()
  ..talents = [FakeApi.categories.first['id']!]
  ..dateOfBirth = '1998-03-14'
  ..profile = {
    'username': 'nkeng_sings',
    'displayName': 'Nkeng Ebai',
    'bio': 'Makossa and soul from Douala.',
    'avatarUrl': null,
    'city': 'Douala',
    'isVerified': false,
  };

Object? asJson(Object? body) => jsonDecode(jsonEncode(body));

Future<void> tap(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key)).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('home feed', () {
    testWidgets(
      'opens on posts, with my picture top left and settings top right',
      (
        tester,
      ) async {
        await pumpApp(tester, member(), tokens: _tokens);

        expect(find.byKey(const ValueKey('home-screen')), findsOneWidget);
        expect(
          find.byKey(const ValueKey('post-${FakeApi.photoPostId}')),
          findsOneWidget,
        );
        expect(
          find.text('Looking for two dancers this weekend in Douala.'),
          findsOneWidget,
        );

        final avatar = tester.getTopLeft(
          find.byKey(const ValueKey('my-avatar')),
        );
        final settings = tester.getTopLeft(
          find.byKey(const ValueKey('open-settings')),
        );
        expect(avatar.dx, lessThan(100));
        expect(settings.dx, greaterThan(250));
        expect(avatar.dy, lessThan(120));
      },
    );

    testWidgets('likes at once and keeps the count in step with the server', (
      tester,
    ) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);

      await tap(tester, 'like-${FakeApi.postId}');

      expect(api.posts[FakeApi.postId]!['likedByMe'], isTrue);
      expect(find.text('5'), findsOneWidget);
      expect(
        api.requests.any(
          (r) =>
              r.method == 'POST' &&
              r.path == '/v1/posts/${FakeApi.postId}/like',
        ),
        isTrue,
      );
    });

    testWidgets('shares a link and counts the share', (tester) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);

      await tap(tester, 'share-${FakeApi.postId}');

      expect(api.shared, [FakeApi.postId]);
    });

    testWidgets('opens a post and adds a comment', (tester) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);
      final l10n = l10nOf(tester);

      await tap(tester, 'comment-${FakeApi.postId}');
      expect(find.text(l10n.commentsEmpty), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('comment-field')),
        'I can dance bikutsi, count me in!',
      );
      await tester.pump();
      await tap(tester, 'send-comment');

      expect(find.text('I can dance bikutsi, count me in!'), findsOneWidget);
      expect(api.comments.single['body'], 'I can dance bikutsi, count me in!');
    });

    testWidgets('writes a post and shows it at the top of the feed', (
      tester,
    ) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);

      await tap(tester, 'compose-prompt');
      await tester.enterText(
        find.byKey(const ValueKey('compose-text')),
        'New single out Friday!\n#makossa',
      );
      await tester.pump();
      await tap(tester, 'publish-post');

      final sent = api.requests.lastWhere((r) => r.path == '/v1/posts');
      expect(asJson(sent.body), {'body': 'New single out Friday!\n#makossa'});
      expect(find.byKey(const ValueKey('home-screen')), findsOneWidget);
      expect(find.textContaining('New single out Friday!'), findsOneWidget);
    });

    testWidgets('the + button offers photo, reel, words and a paid call', (
      tester,
    ) async {
      await pumpApp(tester, member(), tokens: _tokens);

      await tap(tester, 'nav-create');

      for (final key in [
        'create-photo',
        'create-reel',
        'create-text',
        'create-call',
      ]) {
        expect(find.byKey(ValueKey(key)), findsOneWidget);
      }
    });
  });

  group('reels', () {
    testWidgets('shows a stage to post on when there are none', (tester) async {
      await pumpApp(tester, member(), tokens: _tokens);

      await tap(tester, 'nav-reels');

      expect(find.byKey(const ValueKey('post-first-reel')), findsOneWidget);
      expect(find.byKey(const ValueKey('open-settings')), findsWidgets);
    });
  });

  group('profile', () {
    testWidgets('shows my posts, bio and an Edit profile button', (
      tester,
    ) async {
      await pumpApp(tester, member(), tokens: _tokens);

      await tap(tester, 'my-avatar');

      expect(find.text('Nkeng Ebai'), findsWidgets);
      expect(find.text('Makossa and soul from Douala.'), findsOneWidget);
      expect(find.byKey(const ValueKey('edit-profile')), findsOneWidget);
    });

    testWidgets('edits the bio with its own screen, not the sign-up form', (
      tester,
    ) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);
      final l10n = l10nOf(tester);

      await tap(tester, 'my-avatar');
      await tap(tester, 'edit-profile');

      expect(find.byKey(const ValueKey('edit-profile-screen')), findsOneWidget);
      expect(find.byKey(const ValueKey('finish-profile')), findsNothing);
      expect(find.text('Makossa and soul from Douala.'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('bio-field')),
        'Wedding singer. Makossa, soul and gospel.',
      );
      await tester.pump();
      await tap(tester, 'save-profile');

      final sent = api.requests.lastWhere((r) => r.path == '/v1/me/profile');
      expect(asJson(sent.body), {
        'displayName': 'Nkeng Ebai',
        'username': 'nkeng_sings',
        'city': 'Douala',
        'bio': 'Wedding singer. Makossa, soul and gospel.',
      });
      expect(find.text(l10n.editSaved), findsOneWidget);
      expect(
        find.text('Wedding singer. Makossa, soul and gospel.'),
        findsOneWidget,
      );
    });

    testWidgets('asks before throwing away unsaved changes', (tester) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);
      final l10n = l10nOf(tester);

      await tap(tester, 'my-avatar');
      await tap(tester, 'edit-profile');
      await tester.enterText(find.byKey(const ValueKey('city-field')), 'Buea');
      await tester.pump();
      await tester.tap(find.byTooltip(l10n.commonClose));
      await tester.pumpAndSettle();

      expect(find.text(l10n.editDiscardTitle), findsOneWidget);
      await tap(tester, 'discard-changes');
      expect(find.byKey(const ValueKey('edit-profile-screen')), findsNothing);
      expect(api.requests.any((r) => r.path == '/v1/me/profile'), isFalse);
    });
  });

  group('settings', () {
    testWidgets('signs out from the gear at the top right', (tester) async {
      final api = member();
      await pumpApp(tester, api, tokens: _tokens);

      await tap(tester, 'open-settings');
      await tap(tester, 'sign-out');

      expect(find.byKey(const ValueKey('phone-field')), findsOneWidget);
    });
  });
}
