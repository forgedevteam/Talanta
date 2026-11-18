// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostPage _$PostPageFromJson(Map<String, dynamic> json) => _PostPage(
  items: (json['items'] as List<dynamic>)
      .map((e) => Post.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['nextCursor'] as String?,
);

Map<String, dynamic> _$PostPageToJson(_PostPage instance) => <String, dynamic>{
  'items': instance.items,
  'nextCursor': ?instance.nextCursor,
};
