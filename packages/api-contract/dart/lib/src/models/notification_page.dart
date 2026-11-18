// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification.dart';

part 'notification_page.freezed.dart';
part 'notification_page.g.dart';

@Freezed()
abstract class NotificationPage with _$NotificationPage {
  const factory NotificationPage({
    required List<Notification> items,
    required String? nextCursor,
  }) = _NotificationPage;
  
  factory NotificationPage.fromJson(Map<String, Object?> json) => _$NotificationPageFromJson(json);
}
