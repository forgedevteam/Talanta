// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonSummary _$PersonSummaryFromJson(Map<String, dynamic> json) =>
    _PersonSummary(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      city: json['city'] as String?,
      isVerified: json['isVerified'] as bool,
      primaryTalent: json['primaryTalent'] == null
          ? null
          : TalentCategory.fromJson(
              json['primaryTalent'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PersonSummaryToJson(_PersonSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'city': ?instance.city,
      'isVerified': instance.isVerified,
      'primaryTalent': ?instance.primaryTalent,
    };
