// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpportunityFeed _$OpportunityFeedFromJson(Map<String, dynamic> json) =>
    _OpportunityFeed(
      featured: (json['featured'] as List<dynamic>)
          .map((e) => OpportunitySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      items: (json['items'] as List<dynamic>)
          .map((e) => OpportunitySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$OpportunityFeedToJson(_OpportunityFeed instance) =>
    <String, dynamic>{
      'featured': instance.featured,
      'items': instance.items,
      'nextCursor': ?instance.nextCursor,
    };
