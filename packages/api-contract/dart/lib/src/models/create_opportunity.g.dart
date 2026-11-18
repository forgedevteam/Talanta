// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_opportunity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateOpportunity _$CreateOpportunityFromJson(Map<String, dynamic> json) =>
    _CreateOpportunity(
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String,
      city: json['city'] as String,
      compensation: CompensationType.fromJson(json['compensation'] as String),
      budgetAmount: json['budgetAmount'] as num?,
      deadline: json['deadline'] as String?,
    );

Map<String, dynamic> _$CreateOpportunityToJson(_CreateOpportunity instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'city': instance.city,
      'compensation': instance.compensation,
      'budgetAmount': ?instance.budgetAmount,
      'deadline': ?instance.deadline,
    };
