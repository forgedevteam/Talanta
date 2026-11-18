// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'media.dart';
import 'person_summary.dart';
import 'post_kind.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@Freezed()
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required PersonSummary author,
    required PostKind kind,
    required String? body,
    required List<Media> media,

    /// A vertical video that also plays in Reels.
    required bool isReel,
    required num likeCount,
    required num commentCount,
    required num shareCount,
    required bool likedByMe,
    required bool isMine,
    required DateTime createdAt,
  }) = _Post;
  
  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
}
