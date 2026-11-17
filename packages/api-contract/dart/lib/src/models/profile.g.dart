// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  username: json['username'] as String,
  displayName: json['displayName'] as String,
  bio: json['bio'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  city: json['city'] as String?,
  isVerified: json['isVerified'] as bool,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'username': instance.username,
  'displayName': instance.displayName,
  'bio': instance.bio,
  'avatarUrl': instance.avatarUrl,
  'city': instance.city,
  'isVerified': instance.isVerified,
};
