import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// One recorded request.
class FakeRequest {
  const FakeRequest(this.method, this.path, this.body, [this.query = const {}]);

  final String method;
  final String path;
  final Object? body;
  final Map<String, Object?> query;
}

/// A tiny in-memory stand-in for the real API, plugged into Dio as its
/// transport. It behaves like the server for the onboarding flow and lets a
/// test swap in failures per route.
class FakeApi implements HttpClientAdapter {
  FakeApi();

  static const validCode = '246810';
  static const phoneE164 = '+237671234567';
  static const displayPhone = '+237 6 71 23 45 67';

  final List<FakeRequest> requests = [];

  /// Route key (`METHOD /path`) to a canned response that replaces the default.
  final Map<String, FakeResponse> overrides = {};

  List<String> talents = [];
  Map<String, Object?>? profile;
  String? dateOfBirth;

  static const categories = [
    {
      'id': '01000000-0000-7000-8000-000000000001',
      'slug': 'music',
      'name': 'Music',
      'icon': 'music',
    },
    {
      'id': '01000000-0000-7000-8000-000000000002',
      'slug': 'dance',
      'name': 'Dance',
      'icon': 'dance',
    },
    {
      'id': '01000000-0000-7000-8000-000000000003',
      'slug': 'acting',
      'name': 'Acting',
      'icon': 'acting',
    },
    {
      'id': '01000000-0000-7000-8000-000000000004',
      'slug': 'comedy',
      'name': 'Comedy',
      'icon': 'comedy',
    },
    {
      'id': '01000000-0000-7000-8000-000000000005',
      'slug': 'art',
      'name': 'Art',
      'icon': 'art',
    },
    {
      'id': '01000000-0000-7000-8000-000000000006',
      'slug': 'film',
      'name': 'Film',
      'icon': 'film',
    },
  ];

  Map<String, Object?> get me => {
    'id': '01000000-0000-7000-8000-00000000aaaa',
    'phone': phoneE164,
    'country': 'CM',
    'language': 'en',
    'role': 'member',
    'dateOfBirth': dateOfBirth,
    'isMinor': dateOfBirth == null ? null : false,
    'profile': profile,
    'talents': [
      for (final (index, id) in talents.indexed)
        {
          ...categories.firstWhere((category) => category['id'] == id),
          'categoryId': id,
          'level': 'emerging',
          'isPrimary': index == 0,
        },
    ],
    'onboardingStep': talents.isEmpty
        ? 'talents'
        : profile == null || dateOfBirth == null
        ? 'profile'
        : 'done',
  };

  FakeResponse problem(
    int status,
    String code, {
    Map<String, List<String>>? fields,
  }) => FakeResponse(status, {
    'code': code,
    'message': code,
    'fields': ?fields,
  });

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final body = options.data;
    requests.add(
      FakeRequest(options.method, options.path, body, options.queryParameters),
    );
    final key = '${options.method} ${options.path}';
    final response =
        overrides[key] ?? _handle(key, body, options.queryParameters);
    return ResponseBody.fromString(
      response.body == null ? '' : jsonEncode(response.body),
      response.status,
      headers: {
        if (response.body != null) 'content-type': ['application/json'],
      },
    );
  }

  // --- Open Calls, discovery and activity ------------------------------

  static const callId = '01000000-0000-7000-8000-0000000c0001';
  static const featuredCallId = '01000000-0000-7000-8000-0000000c0002';

  /// Open Calls by id. Tests can add or change entries.
  final Map<String, Map<String, Object?>> calls = {
    featuredCallId: _call(
      featuredCallId,
      'Danseurs pour un clip bikutsi',
      categories[1],
      featured: true,
    ),
    callId: _call(callId, 'Singer for a wedding in Douala', categories[0]),
  };

  /// Opportunity id to my application status, for calls I applied to.
  final Map<String, String> applied = {};

  /// Calls posted by the signed-in member.
  final Set<String> postedByMe = {};
  final List<Map<String, Object?>> portfolio = [];
  final List<Map<String, Object?>> notificationItems = [];
  int unreadCount = 0;
  bool accountDeleted = false;

  List<Map<String, Object?>> promotions = [
    {
      'id': '01000000-0000-7000-8000-0000000a0001',
      'sponsorName': 'Talanta',
      'title': 'Your first call is free',
      'body': 'Post a call and hear from real talent.',
      'ctaLabel': 'Post a call',
      'url': 'talanta:post-call',
    },
  ];

  static Map<String, Object?> person(String username, String name) => {
    'id': '01000000-0000-7000-8000-00000000bbbb',
    'username': username,
    'displayName': name,
    'city': 'Yaoundé',
    'isVerified': true,
    'primaryTalent': null,
  };

  static Map<String, Object?> _call(
    String id,
    String title,
    Map<String, String> category, {
    bool featured = false,
  }) => {
    'id': id,
    'title': title,
    'category': category,
    'city': 'Douala',
    'country': 'CM',
    'compensation': 'paid',
    'budgetAmount': 150000,
    'currency': 'XAF',
    'deadline': null,
    'status': 'open',
    'isFeatured': featured,
    'applicationsCount': 0,
    'poster': person('brice_events', 'Brice Mbarga'),
    'createdAt': '2026-11-18T09:00:00.000Z',
  };

  Map<String, Object?> callDetail(String id, {bool mine = false}) {
    final call = calls[id]!;
    final status = applied[id];
    return {
      ...call,
      'description':
          'Two sets of makossa classics at a wedding reception. Sound provided.',
      'isMine': mine,
      'myApplication': status == null
          ? null
          : {'id': '01000000-0000-7000-8000-0000000d0001', 'status': status},
    };
  }

  Map<String, Object?> get myCreatorProfile => {
    'id': '01000000-0000-7000-8000-00000000aaaa',
    'username': profile?['username'] ?? 'me',
    'displayName': profile?['displayName'] ?? 'Me',
    'city': profile?['city'],
    'isVerified': false,
    'primaryTalent': null,
    'bio': null,
    'talents': const <Object?>[],
    'portfolio': portfolio,
    'followerCount': 3,
    'followingCount': 2,
    'isFollowing': false,
    'isMe': true,
  };

  FakeResponse? _handleSocial(String key, Map<String, Object?> json) {
    final detail = RegExp(
      r'^GET /v1/opportunities/([0-9a-f-]+)$',
    ).firstMatch(key);
    if (detail != null) {
      final id = detail.group(1)!;
      return calls.containsKey(id)
          ? FakeResponse(200, callDetail(id, mine: postedByMe.contains(id)))
          : problem(404, 'not_found');
    }
    final apply = RegExp(
      r'^POST /v1/opportunities/([0-9a-f-]+)/applications$',
    ).firstMatch(key);
    if (apply != null) {
      final id = apply.group(1)!;
      if (applied.containsKey(id)) return problem(409, 'already_applied');
      applied[id] = 'submitted';
      return FakeResponse(201, callDetail(id));
    }
    if (RegExp(
      r'^GET /v1/opportunities/[0-9a-f-]+/applications$',
    ).hasMatch(key)) {
      return const FakeResponse(200, <Object?>[]);
    }
    if (RegExp(r'^GET /v1/creators/[a-z0-9_]+$').hasMatch(key)) {
      return FakeResponse(200, myCreatorProfile);
    }
    switch (key) {
      case 'GET /v1/opportunities':
        final all = calls.values.toList();
        return FakeResponse(200, {
          'featured': all.where((c) => c['isFeatured'] == true).toList(),
          'items': all.where((c) => c['isFeatured'] != true).toList(),
          'nextCursor': null,
        });
      case 'POST /v1/opportunities':
        const id = '01000000-0000-7000-8000-0000000c0099';
        postedByMe.add(id);
        calls[id] = {
          ..._call(id, json['title']! as String, categories[0]),
          'compensation': json['compensation'],
          'budgetAmount': json['budgetAmount'],
        };
        return FakeResponse(201, callDetail(id, mine: true));
      case 'GET /v1/promotions':
        return FakeResponse(200, promotions);
      case 'GET /v1/me/opportunities':
        return const FakeResponse(200, <Object?>[]);
      case 'GET /v1/me/applications':
        return FakeResponse(200, [
          for (final entry in applied.entries)
            {
              'applicationId': '01000000-0000-7000-8000-0000000d0001',
              'status': entry.value,
              'createdAt': '2026-11-18T09:00:00.000Z',
              'opportunity': calls[entry.key],
            },
        ]);
      case 'GET /v1/creators':
        return FakeResponse(200, {
          'items': [
            {
              ...person('awa_danse', 'Awa Ngono'),
              'followerCount': 12,
              'portfolioCount': 2,
            },
          ],
          'nextCursor': null,
        });
      case 'GET /v1/feed/following':
        return const FakeResponse(200, {
          'items': <Object?>[],
          'nextCursor': null,
        });
      case 'GET /v1/me/notifications':
        return FakeResponse(200, {
          'items': notificationItems,
          'nextCursor': null,
        });
      case 'GET /v1/me/notifications/unread-count':
        return FakeResponse(200, {'count': unreadCount});
      case 'POST /v1/me/notifications/read-all':
        unreadCount = 0;
        return const FakeResponse(204, null);
      case 'POST /v1/me/portfolio':
        final item = {
          'id': '01000000-0000-7000-8000-0000000e000${portfolio.length}',
          'title': json['title'],
          'description': null,
          'url': json['url'],
          'platform': 'youtube',
          'categorySlug': null,
          'createdAt': '2026-11-18T09:00:00.000Z',
        };
        portfolio.insert(0, item);
        return FakeResponse(201, item);
      case 'POST /v1/reports':
        return const FakeResponse(204, null);
      case 'DELETE /v1/me':
        accountDeleted = true;
        return const FakeResponse(204, null);
    }
    return null;
  }

  FakeResponse _handle(String key, Object? body, Map<String, Object?> query) {
    final json = body is Map<String, Object?>
        ? body
        : const <String, Object?>{};
    final social = _handleSocial(key, json);
    if (social != null) return social;
    switch (key) {
      case 'POST /v1/auth/otp/request':
        return const FakeResponse(200, {
          'phone': phoneE164,
          'displayPhone': displayPhone,
          'expiresInSeconds': 300,
          'resendAfterSeconds': 60,
        });
      case 'POST /v1/auth/otp/verify':
        if (json['code'] != validCode) return problem(400, 'otp_invalid');
        return FakeResponse(200, {
          'tokens': {
            'accessToken': 'access-1',
            'refreshToken': 'refresh-1',
            'accessTokenExpiresIn': 900,
          },
          'isNewUser': true,
          'me': me,
        });
      case 'POST /v1/auth/refresh':
        return problem(401, 'session_expired');
      case 'POST /v1/auth/logout':
        return const FakeResponse(204, null);
      case 'GET /v1/me':
        return FakeResponse(200, me);
      case 'GET /v1/talent-categories':
        return const FakeResponse(200, categories);
      case 'PUT /v1/me/talents':
        final ids = (json['categoryIds']! as List).cast<String>();
        final primary = json['primaryCategoryId'] as String? ?? ids.first;
        talents = [primary, ...ids.where((id) => id != primary)];
        return FakeResponse(200, me);
      case 'PUT /v1/me/profile':
        final username = json['username']! as String;
        if (username == 'taken') return problem(409, 'username_taken');
        final dob = json['dateOfBirth'] as String?;
        if (dateOfBirth == null && dob == null) {
          return problem(
            422,
            'validation_failed',
            fields: {
              'dateOfBirth': ['Enter your date of birth.'],
            },
          );
        }
        dateOfBirth ??= dob;
        profile = {
          'username': username,
          'displayName': json['displayName'],
          'bio': json['bio'],
          'avatarUrl': null,
          'city': json['city'],
          'isVerified': false,
        };
        return FakeResponse(200, me);
      case 'GET /v1/profiles/username-availability':
        final username = query['username']! as String;
        return FakeResponse(200, {
          'username': username,
          'status': username == 'taken'
              ? 'taken'
              : username == 'admin'
              ? 'reserved'
              : 'available',
        });
    }
    return problem(404, 'not_found');
  }

  @override
  void close({bool force = false}) {}
}

class FakeResponse {
  const FakeResponse(this.status, this.body);

  final int status;
  final Object? body;
}
