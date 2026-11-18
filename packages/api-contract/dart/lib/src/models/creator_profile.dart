// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'portfolio_item.dart';
import 'talent_category.dart';
import 'user_talent.dart';

part 'creator_profile.freezed.dart';
part 'creator_profile.g.dart';

@Freezed()
abstract class CreatorProfile with _$CreatorProfile {
  const factory CreatorProfile({
    required String id,
    required String username,
    required String displayName,
    required String? city,

    /// Absolute, or relative to the API origin.
    required String? avatarUrl,
    required bool isVerified,
    required TalentCategory? primaryTalent,
    required String? bio,
    required List<UserTalent> talents,
    required List<PortfolioItem> portfolio,
    required num followerCount,
    required num followingCount,
    required num postCount,
    required bool isFollowing,

    /// This is the signed-in person.
    required bool isMe,
  }) = _CreatorProfile;
  
  factory CreatorProfile.fromJson(Map<String, Object?> json) => _$CreatorProfileFromJson(json);
}
