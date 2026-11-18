// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Media _$MediaFromJson(Map<String, dynamic> json) => _Media(
  id: json['id'] as String,
  kind: MediaKind.fromJson(json['kind'] as String),
  url: json['url'] as String,
  width: json['width'] as num?,
  height: json['height'] as num?,
);

Map<String, dynamic> _$MediaToJson(_Media instance) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'url': instance.url,
  'width': ?instance.width,
  'height': ?instance.height,
};
