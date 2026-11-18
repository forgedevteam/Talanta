import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta_api/talanta_api.dart';

/// `YYYY-MM-DD`, the format the API expects for calendar dates.
String isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Saves onboarding answers and pushes the returned `Me` into the session,
/// which is what moves the router to the next step.
class OnboardingController {
  const OnboardingController(this._ref);

  final Ref _ref;

  TalantaApi get _api => _ref.read(apiProvider);

  Future<Me> saveTalents({
    required List<String> categoryIds,
    String? primaryCategoryId,
  }) async {
    try {
      final me = await _api.me.setMyTalents(
        body: SetTalents(
          categoryIds: categoryIds,
          primaryCategoryId: primaryCategoryId,
        ),
      );
      _ref.read(sessionProvider.notifier).updateMe(me);
      return me;
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  Future<Me> saveProfile({
    required String displayName,
    required String username,
    required String city,
    DateTime? dateOfBirth,
  }) async {
    try {
      final me = await _api.me.saveMyProfile(
        body: UpdateProfile(
          displayName: displayName,
          username: username,
          city: city,
          dateOfBirth: dateOfBirth == null ? null : isoDate(dateOfBirth),
        ),
      );
      _ref.read(sessionProvider.notifier).updateMe(me);
      return me;
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  Future<UsernameStatus> checkUsername(String username) async {
    try {
      final result = await _api.profiles.checkUsername(username: username);
      return result.status;
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }
}

final onboardingControllerProvider = Provider<OnboardingController>(
  OnboardingController.new,
);
