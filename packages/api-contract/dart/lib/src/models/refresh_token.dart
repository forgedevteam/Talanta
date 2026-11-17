// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token.freezed.dart';
part 'refresh_token.g.dart';

@Freezed()
abstract class RefreshToken with _$RefreshToken {
  const factory RefreshToken({
    required String refreshToken,
  }) = _RefreshToken;
  
  factory RefreshToken.fromJson(Map<String, Object?> json) => _$RefreshTokenFromJson(json);
}
