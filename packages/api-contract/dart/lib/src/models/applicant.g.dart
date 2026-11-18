// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Applicant _$ApplicantFromJson(Map<String, dynamic> json) => _Applicant(
  applicationId: json['applicationId'] as String,
  status: ApplicationStatus.fromJson(json['status'] as String),
  message: json['message'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  applicant: PersonSummary.fromJson(json['applicant'] as Map<String, dynamic>),
  portfolioItem: json['portfolioItem'] == null
      ? null
      : PortfolioItem.fromJson(json['portfolioItem'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApplicantToJson(_Applicant instance) =>
    <String, dynamic>{
      'applicationId': instance.applicationId,
      'status': instance.status,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
      'applicant': instance.applicant,
      'portfolioItem': ?instance.portfolioItem,
    };
