import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/providers.dart';
import 'package:talanta_api/talanta_api.dart';

/// The public list of talents, fetched once per app run.
final talentCategoriesProvider = FutureProvider<List<TalentCategory>>((
  ref,
) async {
  try {
    return await ref.watch(apiProvider).talents.listTalentCategories();
  } on Object catch (error) {
    throw ApiFailure.from(error);
  }
});
