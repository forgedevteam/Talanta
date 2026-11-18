// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpportunityDetail _$OpportunityDetailFromJson(Map<String, dynamic> json) =>
    _OpportunityDetail(
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
      description: json['description'] as String,
      isMine: json['isMine'] as bool,
      myApplication: json['myApplication'] == null
          ? null
          : MyApplicationRef.fromJson(
              json['myApplication'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OpportunityDetailToJson(_OpportunityDetail instance) =>
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
      'description': instance.description,
      'isMine': instance.isMine,
      'myApplication': ?instance.myApplication,
    };
