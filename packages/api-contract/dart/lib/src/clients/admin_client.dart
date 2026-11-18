// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/feature_opportunity.dart';
import '../models/opportunity_detail.dart';
import '../models/report.dart';

part 'admin_client.g.dart';

@RestApi()
abstract class AdminClient {
  factory AdminClient(Dio dio, {String? baseUrl}) = _AdminClient;

  /// Open reports, oldest first
  @GET('/v1/admin/reports')
  Future<List<Report>> listOpenReports();

  /// Close a report
  @POST('/v1/admin/reports/{id}/resolve')
  Future<void> resolveReport({
    @Path('id') required String id,
  });

  /// Put a call in the Featured row (paid placement)
  @POST('/v1/admin/opportunities/{id}/feature')
  Future<OpportunityDetail> featureOpportunity({
    @Path('id') required String id,
    @Body() required FeatureOpportunity body,
  });

  /// Take down a call
  @POST('/v1/admin/opportunities/{id}/remove')
  Future<void> removeOpportunity({
    @Path('id') required String id,
  });

  /// Take down a post
  @POST('/v1/admin/posts/{id}/remove')
  Future<void> removePost({
    @Path('id') required String id,
  });

  /// Suspend an account and sign it out everywhere
  @POST('/v1/admin/users/{id}/suspend')
  Future<void> suspendUser({
    @Path('id') required String id,
  });
}
