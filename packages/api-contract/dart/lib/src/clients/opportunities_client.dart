// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/applicant.dart';
import '../models/apply.dart';
import '../models/create_opportunity.dart';
import '../models/decide_application.dart';
import '../models/my_application.dart';
import '../models/opportunity_detail.dart';
import '../models/opportunity_feed.dart';
import '../models/opportunity_summary.dart';

part 'opportunities_client.g.dart';

@RestApi()
abstract class OpportunitiesClient {
  factory OpportunitiesClient(Dio dio, {String? baseUrl}) = _OpportunitiesClient;

  /// Open Calls, newest first, with featured calls on the first page.
  ///
  /// [cursor] - The `nextCursor` from the previous page.
  ///
  /// [category] - Talent category slug.
  @GET('/v1/opportunities')
  Future<OpportunityFeed> listOpportunities({
    @Query('limit') num? limit = 20,
    @Query('cursor') String? cursor,
    @Query('category') String? category,
    @Query('city') String? city,
  });

  /// Post an Open Call
  @POST('/v1/opportunities')
  Future<OpportunityDetail> postOpportunity({
    @Body() required CreateOpportunity body,
  });

  /// One Open Call, with my application if I applied
  @GET('/v1/opportunities/{id}')
  Future<OpportunityDetail> getOpportunity({
    @Path('id') required String id,
  });

  /// Stop taking applications for my call
  @POST('/v1/opportunities/{id}/close')
  Future<OpportunityDetail> closeOpportunity({
    @Path('id') required String id,
  });

  /// Apply to an Open Call
  @POST('/v1/opportunities/{id}/applications')
  Future<OpportunityDetail> applyToOpportunity({
    @Path('id') required String id,
    @Body() required Apply body,
  });

  /// People who applied to my call
  @GET('/v1/opportunities/{id}/applications')
  Future<List<Applicant>> listApplicants({
    @Path('id') required String id,
  });

  /// Shortlist, decline or hire an applicant to my call
  @PATCH('/v1/applications/{id}')
  Future<Applicant> decideApplication({
    @Path('id') required String id,
    @Body() required DecideApplication body,
  });

  /// Calls I posted
  @GET('/v1/me/opportunities')
  Future<List<OpportunitySummary>> listMyOpportunities();

  /// Calls I applied to, with where each one stands
  @GET('/v1/me/applications')
  Future<List<MyApplication>> listMyApplications();
}
