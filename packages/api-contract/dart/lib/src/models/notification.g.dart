// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    _Notification(
      id: json['id'] as String,
      type: NotificationType.fromJson(json['type'] as String),
      actor: json['actor'] == null
          ? null
          : PersonSummary.fromJson(json['actor'] as Map<String, dynamic>),
      opportunityId: json['opportunityId'] as String?,
      opportunityTitle: json['opportunityTitle'] as String?,
      applicationStatus: json['applicationStatus'] == null
          ? null
          : ApplicationStatus.fromJson(json['applicationStatus'] as String),
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationToJson(_Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'actor': ?instance.actor,
      'opportunityId': ?instance.opportunityId,
      'opportunityTitle': ?instance.opportunityTitle,
      'applicationStatus': ?instance.applicationStatus,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };
