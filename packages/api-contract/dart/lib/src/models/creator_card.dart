// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'talent_category.dart';

part 'creator_card.freezed.dart';
part 'creator_card.g.dart';

@Freezed()
abstract class CreatorCard with _$CreatorCard {
  const factory CreatorCard({
    required String id,
    required String username,
    required String displayName,
    required String? city,

    /// Absolute, or relative to the API origin.
    required String? avatarUrl,
    required bool isVerified,
    required TalentCategory? primaryTalent,
    required num followerCount,
    required num portfolioCount,
  }) = _CreatorCard;
  
  factory CreatorCard.fromJson(Map<String, Object?> json) => _$CreatorCardFromJson(json);
}
