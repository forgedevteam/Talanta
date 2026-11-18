// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Apply _$ApplyFromJson(Map<String, dynamic> json) => _Apply(
  message: json['message'] as String,
  portfolioItemId: json['portfolioItemId'] as String?,
);

Map<String, dynamic> _$ApplyToJson(_Apply instance) => <String, dynamic>{
  'message': instance.message,
  'portfolioItemId': ?instance.portfolioItemId,
};
