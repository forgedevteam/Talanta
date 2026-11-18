// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProfile _$UpdateProfileFromJson(Map<String, dynamic> json) =>
    _UpdateProfile(
      displayName: json['displayName'] as String,
      username: json['username'] as String,
      city: json['city'] as String,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$UpdateProfileToJson(_UpdateProfile instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'username': instance.username,
      'city': instance.city,
      'bio': ?instance.bio,
    };
