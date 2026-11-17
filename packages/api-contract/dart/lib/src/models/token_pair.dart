// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair.freezed.dart';
part 'token_pair.g.dart';

@Freezed()
abstract class TokenPair with _$TokenPair {
  const factory TokenPair({
    /// Send as `Authorization: Bearer <token>`.
    required String accessToken,

    /// Single use. Each refresh returns a new one.
    required String refreshToken,

    /// Access token lifetime in seconds.
    required num accessTokenExpiresIn,
  }) = _TokenPair;
  
  factory TokenPair.fromJson(Map<String, Object?> json) => _$TokenPairFromJson(json);
}
