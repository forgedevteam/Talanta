// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: json['id'] as String,
  postId: json['postId'] as String,
  author: PersonSummary.fromJson(json['author'] as Map<String, dynamic>),
  body: json['body'] as String,
  canDelete: json['canDelete'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'postId': instance.postId,
  'author': instance.author,
  'body': instance.body,
  'canDelete': instance.canDelete,
  'createdAt': instance.createdAt.toIso8601String(),
};
