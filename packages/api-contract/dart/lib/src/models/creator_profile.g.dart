// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creator_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatorProfile _$CreatorProfileFromJson(Map<String, dynamic> json) =>
    _CreatorProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      city: json['city'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      isVerified: json['isVerified'] as bool,
      primaryTalent: json['primaryTalent'] == null
          ? null
          : TalentCategory.fromJson(
              json['primaryTalent'] as Map<String, dynamic>,
            ),
      bio: json['bio'] as String?,
      talents: (json['talents'] as List<dynamic>)
          .map((e) => UserTalent.fromJson(e as Map<String, dynamic>))
          .toList(),
      portfolio: (json['portfolio'] as List<dynamic>)
          .map((e) => PortfolioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      followerCount: json['followerCount'] as num,
      followingCount: json['followingCount'] as num,
      postCount: json['postCount'] as num,
      isFollowing: json['isFollowing'] as bool,
      isMe: json['isMe'] as bool,
    );

Map<String, dynamic> _$CreatorProfileToJson(_CreatorProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'city': ?instance.city,
      'avatarUrl': ?instance.avatarUrl,
      'isVerified': instance.isVerified,
      'primaryTalent': ?instance.primaryTalent,
      'bio': ?instance.bio,
      'talents': instance.talents,
      'portfolio': instance.portfolio,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'postCount': instance.postCount,
      'isFollowing': instance.isFollowing,
      'isMe': instance.isMe,
    };
