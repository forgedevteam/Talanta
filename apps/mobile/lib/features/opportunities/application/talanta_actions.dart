import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta/features/activity/application/activity_providers.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/discover/application/discover_providers.dart';
import 'package:talanta/features/opportunities/application/opportunities_providers.dart';
import 'package:talanta_api/talanta_api.dart';

/// Every write the app makes after onboarding. Each turns failures into an
/// [ApiFailure] and refreshes the screens that show what changed.
class TalantaActions {
  const TalantaActions(this._ref);

  final Ref _ref;

  TalantaApi get _api => _ref.read(apiProvider);

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on Object catch (error) {
      throw ApiFailure.from(error);
    }
  }

  Future<OpportunityDetail> postOpportunity(CreateOpportunity body) async {
    final created = await _run(
      () => _api.opportunities.postOpportunity(body: body),
    );
    _ref
      ..invalidate(myOpportunitiesProvider)
      ..invalidate(opportunitiesFeedProvider);
    return created;
  }

  Future<OpportunityDetail> apply(
    String opportunityId, {
    required String message,
    String? portfolioItemId,
  }) async {
    final updated = await _run(
      () => _api.opportunities.applyToOpportunity(
        id: opportunityId,
        body: Apply(message: message, portfolioItemId: portfolioItemId),
      ),
    );
    _ref
      ..invalidate(opportunityProvider(opportunityId))
      ..invalidate(myApplicationsProvider);
    return updated;
  }

  Future<void> closeOpportunity(String opportunityId) async {
    await _run(() => _api.opportunities.closeOpportunity(id: opportunityId));
    _ref
      ..invalidate(opportunityProvider(opportunityId))
      ..invalidate(myOpportunitiesProvider)
      ..invalidate(opportunitiesFeedProvider);
  }

  Future<void> decide(
    String opportunityId,
    String applicationId,
    ApplicationDecision decision,
  ) async {
    await _run(
      () => _api.opportunities.decideApplication(
        id: applicationId,
        body: DecideApplication(status: decision),
      ),
    );
    _ref.invalidate(applicantsProvider(opportunityId));
  }

  Future<FollowState> follow(String username, {required bool follow}) async {
    final state = await _run(
      () => follow
          ? _api.creators.followCreator(username: username)
          : _api.creators.unfollowCreator(username: username),
    );
    _ref
      ..invalidate(creatorProvider(username))
      ..invalidate(followingFeedProvider);
    return state;
  }

  Future<void> addPortfolioItem(CreatePortfolioItem body) async {
    await _run(() => _api.portfolio.addPortfolioItem(body: body));
    _invalidateMyProfile();
  }

  Future<void> removePortfolioItem(String id) async {
    await _run(() => _api.portfolio.removePortfolioItem(id: id));
    _invalidateMyProfile();
  }

  Future<void> report(
    ReportTarget target,
    String targetId,
    ReportReason reason,
  ) => _run(
    () => _api.safety.createReport(
      body: CreateReport(
        targetType: target,
        targetId: targetId,
        reason: reason,
      ),
    ),
  );

  Future<void> markAllRead() async {
    await _run(_api.activity.markAllRead);
    _ref.invalidate(unreadCountProvider);
  }

  Future<void> deleteAccount() async {
    await _run(_api.me.deleteMyAccount);
    await _ref.read(sessionProvider.notifier).accountDeleted();
  }

  void _invalidateMyProfile() {
    final session = _ref.read(sessionProvider);
    final username = session is SignedIn ? session.me.profile?.username : null;
    if (username != null) _ref.invalidate(creatorProvider(username));
  }
}

final talantaActionsProvider = Provider<TalantaActions>(TalantaActions.new);
