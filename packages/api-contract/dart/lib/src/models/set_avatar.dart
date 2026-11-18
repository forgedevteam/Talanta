// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_avatar.freezed.dart';
part 'set_avatar.g.dart';

@Freezed()
abstract class SetAvatar with _$SetAvatar {
  const factory SetAvatar({
    /// A photo I uploaded with purpose=avatar.
    required String mediaId,
  }) = _SetAvatar;
  
  factory SetAvatar.fromJson(Map<String, Object?> json) => _$SetAvatarFromJson(json);
}
