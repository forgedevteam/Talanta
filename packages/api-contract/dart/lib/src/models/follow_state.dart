// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_state.freezed.dart';
part 'follow_state.g.dart';

@Freezed()
abstract class FollowState with _$FollowState {
  const factory FollowState({
    required bool isFollowing,
    required num followerCount,
  }) = _FollowState;
  
  factory FollowState.fromJson(Map<String, Object?> json) => _$FollowStateFromJson(json);
}
