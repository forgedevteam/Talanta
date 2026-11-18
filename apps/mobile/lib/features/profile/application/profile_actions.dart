import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/discover/application/discover_providers.dart';
import 'package:talanta/features/posts/application/post_actions.dart';
import 'package:talanta_api/talanta_api.dart';

/// Changes to my own profile: details, bio and picture.
class ProfileActions {
  const ProfileActions(this._ref);

  final Ref _ref;

  TalantaApi get _api => _ref.read(apiProvider);

  String? get _username {
    final session = _ref.read(sessionProvider);
    return session is SignedIn ? session.me.profile?.username : null;
  }

  void _apply(Me me, {String? previousUsername}) {
    _ref.read(sessionProvider.notifier).updateMe(me);
    for (final name in {previousUsername, me.profile?.username}) {
      if (name != null) _ref.invalidate(creatorProvider(name));
    }
  }

  Future<Me> save({
    required String displayName,
    required String username,
    required String city,
    required String bio,
  }) async {
    final previous = _username;
    try {
      final me = await _api.me.saveMyProfile(
        body: UpdateProfile(
          displayName: displayName,
          username: username,
          city: city,
          // Sent even when empty: an emptied box clears the bio.
          bio: bio,
        ),
      );
      _apply(me, previousUsername: previous);
      return me;
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  /// Uploads a photo, cropped square on the server, and makes it my picture.
  Future<Me> setPicture(
    String path, {
    void Function(double)? onProgress,
  }) async {
    try {
      final media = await _ref
          .read(postActionsProvider)
          .upload(path, purpose: MediaPurpose.avatar, onProgress: onProgress);
      final me = await _api.me.setMyAvatar(body: SetAvatar(mediaId: media.id));
      _apply(me);
      return me;
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  Future<Me> removePicture() async {
    try {
      final me = await _api.me.removeMyAvatar();
      _apply(me);
      return me;
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }
}

final profileActionsProvider = Provider<ProfileActions>(ProfileActions.new);
