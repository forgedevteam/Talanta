// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_state.freezed.dart';
part 'like_state.g.dart';

@Freezed()
abstract class LikeState with _$LikeState {
  const factory LikeState({
    required bool liked,
    required num likeCount,
  }) = _LikeState;
  
  factory LikeState.fromJson(Map<String, Object?> json) => _$LikeStateFromJson(json);
}
