// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'person_summary.dart';
import 'portfolio_platform.dart';

part 'following_work.freezed.dart';
part 'following_work.g.dart';

@Freezed()
abstract class FollowingWork with _$FollowingWork {
  const factory FollowingWork({
    required String id,
    required String title,
    required String? description,
    required String url,
    required PortfolioPlatform platform,
    required String? categorySlug,
    required DateTime createdAt,
    required PersonSummary creator,
  }) = _FollowingWork;
  
  factory FollowingWork.fromJson(Map<String, Object?> json) => _$FollowingWorkFromJson(json);
}
