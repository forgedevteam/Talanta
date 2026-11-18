import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// One recorded request.
class FakeRequest {
  const FakeRequest(this.method, this.path, this.body);

  final String method;
  final String path;
  final Object? body;
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
    requests.add(FakeRequest(options.method, options.path, body));
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

  FakeResponse _handle(String key, Object? body, Map<String, Object?> query) {
    final json = body is Map<String, Object?>
        ? body
        : const <String, Object?>{};
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
