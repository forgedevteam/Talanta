// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatePromotion _$CreatePromotionFromJson(Map<String, dynamic> json) =>
    _CreatePromotion(
      placement: PromotionPlacement.fromJson(json['placement'] as String),
      sponsorName: json['sponsorName'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      ctaLabel: json['ctaLabel'] as String,
      url: json['url'] as String,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
    );

Map<String, dynamic> _$CreatePromotionToJson(_CreatePromotion instance) =>
    <String, dynamic>{
      'placement': instance.placement,
      'sponsorName': instance.sponsorName,
      'title': instance.title,
      'body': instance.body,
      'ctaLabel': instance.ctaLabel,
      'url': instance.url,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
    };
