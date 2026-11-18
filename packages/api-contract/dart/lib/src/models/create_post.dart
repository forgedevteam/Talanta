// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post.freezed.dart';
part 'create_post.g.dart';

@Freezed()
abstract class CreatePost with _$CreatePost {
  const factory CreatePost({
    String? body,

    /// Uploaded files, in display order: up to 10 photos, or one video.
    List<String>? mediaIds,

    /// Show this video in Reels too.
    bool? isReel,
  }) = _CreatePost;
  
  factory CreatePost.fromJson(Map<String, Object?> json) => _$CreatePostFromJson(json);
}
