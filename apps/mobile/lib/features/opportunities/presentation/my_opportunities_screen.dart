import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/opportunities/application/opportunities_providers.dart';
import 'package:talanta/features/opportunities/presentation/opportunity_card.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

class MyOpportunitiesScreen extends ConsumerWidget {
  const MyOpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mine = ref.watch(myOpportunitiesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myCallsTitle)),
      body: mine.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => TalantaErrorState(
          error: error,
          onRetry: () => ref.invalidate(myOpportunitiesProvider),
        ),
        data: (list) => list.isEmpty
            ? TalantaEmptyState(
                icon: Icons.campaign_outlined,
                title: l10n.myCallsEmpty,
                actionLabel: l10n.callsPost,
                onAction: () => unawaited(context.push(Routes.postCall)),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(TalantaSpacing.x5),
                itemCount: list.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: TalantaSpacing.x3),
                itemBuilder: (_, index) => OpportunityCard(
                  opportunity: list[index],
                  onTap: () =>
                      unawaited(context.push(Routes.call(list[index].id))),
                ),
              ),
      ),
    );
  }
}
