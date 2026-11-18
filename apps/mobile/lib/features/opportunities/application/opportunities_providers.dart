import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta_api/talanta_api.dart';

/// The Open Calls feed: featured row, the list, and paging.
class FeedState {
  const FeedState({
    this.category,
    this.featured = const [],
    this.items = const [],
    this.nextCursor,
    this.loading = true,
    this.loadingMore = false,
    this.error,
  });

  final String? category;
  final List<OpportunitySummary> featured;
  final List<OpportunitySummary> items;
  final String? nextCursor;
  final bool loading;
  final bool loadingMore;
  final ApiFailure? error;

  bool get hasMore => nextCursor != null;
  bool get isEmpty => featured.isEmpty && items.isEmpty;

  FeedState copyWith({
    List<OpportunitySummary>? featured,
    List<OpportunitySummary>? items,
    String? nextCursor,
    bool clearCursor = false,
    bool? loading,
    bool? loadingMore,
    ApiFailure? error,
    bool clearError = false,
  }) => FeedState(
    category: category,
    featured: featured ?? this.featured,
    items: items ?? this.items,
    nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : (error ?? this.error),
  );
}

class OpportunitiesFeed extends Notifier<FeedState> {
  @override
  FeedState build() {
    unawaited(Future<void>.microtask(refresh));
    return const FeedState();
  }

  TalantaApi get _api => ref.read(apiProvider);

  Future<void> setCategory(String? slug) async {
    if (slug == state.category) return;
    state = FeedState(category: slug);
    await refresh();
  }

  Future<void> refresh() async {
    final category = state.category;
    state = state.copyWith(loading: true, clearError: true);
    try {
      final page = await _api.opportunities.listOpportunities(
        category: category,
      );
      if (state.category != category) return;
      state = FeedState(
        category: category,
        featured: page.featured,
        items: page.items,
        nextCursor: page.nextCursor,
        loading: false,
      );
    } on Object catch (error) {
      state = state.copyWith(loading: false, error: ApiFailure.from(error));
    }
  }

  Future<void> loadMore() async {
    final cursor = state.nextCursor;
    if (cursor == null || state.loadingMore || state.loading) return;
    state = state.copyWith(loadingMore: true);
    try {
      final page = await _api.opportunities.listOpportunities(
        category: state.category,
        cursor: cursor,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
        loadingMore: false,
      );
    } on Object {
      // A failed extra page is retried by scrolling again.
      state = state.copyWith(loadingMore: false);
    }
  }
}

final opportunitiesFeedProvider =
    NotifierProvider<OpportunitiesFeed, FeedState>(OpportunitiesFeed.new);

/// Sponsored cards for the feed. Failing to load them never hurts the feed.
final feedPromotionsProvider = FutureProvider.autoDispose<List<Promotion>>((
  ref,
) async {
  try {
    return await ref
        .read(apiProvider)
        .promotions
        .listPromotions(placement: PromotionPlacement.opportunitiesFeed);
  } on Object {
    return const [];
  }
});

final opportunityProvider = FutureProvider.autoDispose
    .family<OpportunityDetail, String>(
      (ref, id) => ref.read(apiProvider).opportunities.getOpportunity(id: id),
    );

final applicantsProvider = FutureProvider.autoDispose
    .family<List<Applicant>, String>(
      (ref, id) => ref.read(apiProvider).opportunities.listApplicants(id: id),
    );

final myOpportunitiesProvider =
    FutureProvider.autoDispose<List<OpportunitySummary>>(
      (ref) => ref.read(apiProvider).opportunities.listMyOpportunities(),
    );

final myApplicationsProvider = FutureProvider.autoDispose<List<MyApplication>>(
  (ref) => ref.read(apiProvider).opportunities.listMyApplications(),
);
