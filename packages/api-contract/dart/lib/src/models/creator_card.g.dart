// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creator_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatorCard _$CreatorCardFromJson(Map<String, dynamic> json) => _CreatorCard(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['displayName'] as String,
  city: json['city'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  isVerified: json['isVerified'] as bool,
  primaryTalent: json['primaryTalent'] == null
      ? null
      : TalentCategory.fromJson(json['primaryTalent'] as Map<String, dynamic>),
  followerCount: json['followerCount'] as num,
  portfolioCount: json['portfolioCount'] as num,
);

Map<String, dynamic> _$CreatorCardToJson(_CreatorCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'city': ?instance.city,
      'avatarUrl': ?instance.avatarUrl,
      'isVerified': instance.isVerified,
      'primaryTalent': ?instance.primaryTalent,
      'followerCount': instance.followerCount,
      'portfolioCount': instance.portfolioCount,
    };
