// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentPage _$CommentPageFromJson(Map<String, dynamic> json) => _CommentPage(
  items: (json['items'] as List<dynamic>)
      .map((e) => Comment.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$CommentPageToJson(_CommentPage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': ?instance.nextCursor,
    };
