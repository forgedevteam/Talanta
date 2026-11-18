// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'application_status.dart';
import 'notification_type.dart';
import 'person_summary.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@Freezed()
abstract class Notification with _$Notification {
  const factory Notification({
    required String id,
    required NotificationType type,
    required PersonSummary? actor,
    required String? opportunityId,
    required String? opportunityTitle,

    /// The application’s current status, for status notifications.
    required ApplicationStatus? applicationStatus,
    required bool isRead,
    required DateTime createdAt,
  }) = _Notification;
  
  factory Notification.fromJson(Map<String, Object?> json) => _$NotificationFromJson(json);
}
