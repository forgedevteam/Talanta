// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  tokens: TokenPair.fromJson(json['tokens'] as Map<String, dynamic>),
  isNewUser: json['isNewUser'] as bool,
  me: Me.fromJson(json['me'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) =>
    <String, dynamic>{
      'tokens': instance.tokens,
      'isNewUser': instance.isNewUser,
      'me': instance.me,
    };
