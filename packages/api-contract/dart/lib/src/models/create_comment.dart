// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_comment.freezed.dart';
part 'create_comment.g.dart';

@Freezed()
abstract class CreateComment with _$CreateComment {
  const factory CreateComment({
    required String body,
  }) = _CreateComment;
  
  factory CreateComment.fromJson(Map<String, Object?> json) => _$CreateCommentFromJson(json);
}
