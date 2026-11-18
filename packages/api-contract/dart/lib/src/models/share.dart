// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'share.freezed.dart';
part 'share.g.dart';

@Freezed()
abstract class Share with _$Share {
  const factory Share({
    required String url,
    required num shareCount,
  }) = _Share;
  
  factory Share.fromJson(Map<String, Object?> json) => _$ShareFromJson(json);
}
