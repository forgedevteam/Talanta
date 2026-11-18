// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpportunitySummary _$OpportunitySummaryFromJson(Map<String, dynamic> json) =>
    _OpportunitySummary(
      id: json['id'] as String,
      title: json['title'] as String,
      category: TalentCategory.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      city: json['city'] as String,
      country: json['country'] as String,
      compensation: CompensationType.fromJson(json['compensation'] as String),
      budgetAmount: json['budgetAmount'] as num?,
      currency: json['currency'] as String,
      deadline: json['deadline'] as String?,
      status: OpportunityStatus.fromJson(json['status'] as String),
      isFeatured: json['isFeatured'] as bool,
      applicationsCount: json['applicationsCount'] as num,
      poster: json['poster'] == null
          ? null
          : PersonSummary.fromJson(json['poster'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$OpportunitySummaryToJson(_OpportunitySummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'city': instance.city,
      'country': instance.country,
      'compensation': instance.compensation,
      'budgetAmount': ?instance.budgetAmount,
      'currency': instance.currency,
      'deadline': ?instance.deadline,
      'status': instance.status,
      'isFeatured': instance.isFeatured,
      'applicationsCount': instance.applicationsCount,
      'poster': ?instance.poster,
      'createdAt': instance.createdAt.toIso8601String(),
    };
