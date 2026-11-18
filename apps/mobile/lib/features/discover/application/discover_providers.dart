import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta_api/talanta_api.dart';

/// What the Discover search box and talent chips are set to.
@immutable
class CreatorSearch {
  const CreatorSearch({this.query = '', this.talent});

  final String query;
  final String? talent;

  @override
  bool operator ==(Object other) =>
      other is CreatorSearch && other.query == query && other.talent == talent;

  @override
  int get hashCode => Object.hash(query, talent);
}

final creatorSearchProvider = FutureProvider.autoDispose
    .family<CreatorPage, CreatorSearch>((ref, search) {
      final query = search.query.trim();
      return ref
          .read(apiProvider)
          .creators
          .searchCreators(
            q: query.isEmpty ? null : query,
            talent: search.talent,
            limit: 30,
          );
    });

final followingFeedProvider = FutureProvider.autoDispose<FollowingFeed>(
  (ref) => ref.read(apiProvider).creators.getFollowingFeed(limit: 40),
);

final creatorProvider = FutureProvider.autoDispose
    .family<CreatorProfile, String>(
      (ref, username) =>
          ref.read(apiProvider).creators.getCreator(username: username),
    );
