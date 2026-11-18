// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'unread_count.freezed.dart';
part 'unread_count.g.dart';

@Freezed()
abstract class UnreadCount with _$UnreadCount {
  const factory UnreadCount({
    required num count,
  }) = _UnreadCount;
  
  factory UnreadCount.fromJson(Map<String, Object?> json) => _$UnreadCountFromJson(json);
}
