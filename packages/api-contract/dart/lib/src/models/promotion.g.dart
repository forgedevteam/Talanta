// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Promotion _$PromotionFromJson(Map<String, dynamic> json) => _Promotion(
  id: json['id'] as String,
  sponsorName: json['sponsorName'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  ctaLabel: json['ctaLabel'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$PromotionToJson(_Promotion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sponsorName': instance.sponsorName,
      'title': instance.title,
      'body': instance.body,
      'ctaLabel': instance.ctaLabel,
      'url': instance.url,
    };
