// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'person_summary.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@Freezed()
abstract class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String postId,
    required PersonSummary author,
    required String body,

    /// I can delete it: I wrote it, or it is on my post.
    required bool canDelete,
    required DateTime createdAt,
  }) = _Comment;
  
  factory Comment.fromJson(Map<String, Object?> json) => _$CommentFromJson(json);
}
