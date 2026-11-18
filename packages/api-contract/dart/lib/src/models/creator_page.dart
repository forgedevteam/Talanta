// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'creator_card.dart';

part 'creator_page.freezed.dart';
part 'creator_page.g.dart';

@Freezed()
abstract class CreatorPage with _$CreatorPage {
  const factory CreatorPage({
    required List<CreatorCard> items,
    required String? nextCursor,
  }) = _CreatorPage;
  
  factory CreatorPage.fromJson(Map<String, Object?> json) => _$CreatorPageFromJson(json);
}
