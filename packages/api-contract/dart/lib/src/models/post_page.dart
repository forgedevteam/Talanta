// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'post.dart';

part 'post_page.freezed.dart';
part 'post_page.g.dart';

@Freezed()
abstract class PostPage with _$PostPage {
  const factory PostPage({
    required List<Post> items,
    required String? nextCursor,
  }) = _PostPage;
  
  factory PostPage.fromJson(Map<String, Object?> json) => _$PostPageFromJson(json);
}
