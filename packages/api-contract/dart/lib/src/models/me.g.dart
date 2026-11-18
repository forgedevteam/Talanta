// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Me _$MeFromJson(Map<String, dynamic> json) => _Me(
  id: json['id'] as String,
  phone: json['phone'] as String?,
  country: json['country'] as String?,
  language: json['language'] as String,
  role: UserRole.fromJson(json['role'] as String),
  profile: json['profile'] == null
      ? null
      : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  talents: (json['talents'] as List<dynamic>)
      .map((e) => UserTalent.fromJson(e as Map<String, dynamic>))
      .toList(),
  onboardingStep: OnboardingStep.fromJson(json['onboardingStep'] as String),
);

Map<String, dynamic> _$MeToJson(_Me instance) => <String, dynamic>{
  'id': instance.id,
  'phone': ?instance.phone,
  'country': ?instance.country,
  'language': instance.language,
  'role': instance.role,
  'profile': ?instance.profile,
  'talents': instance.talents,
  'onboardingStep': instance.onboardingStep,
};
