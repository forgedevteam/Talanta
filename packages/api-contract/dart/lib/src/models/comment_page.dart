// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment.dart';

part 'comment_page.freezed.dart';
part 'comment_page.g.dart';

@Freezed()
abstract class CommentPage with _$CommentPage {
  const factory CommentPage({
    required List<Comment> items,
    required String? nextCursor,
  }) = _CommentPage;
  
  factory CommentPage.fromJson(Map<String, Object?> json) => _$CommentPageFromJson(json);
}
