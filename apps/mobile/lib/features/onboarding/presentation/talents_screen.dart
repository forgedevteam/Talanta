import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/onboarding/application/onboarding_controller.dart';
import 'package:talanta/features/onboarding/application/talent_categories_provider.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

const maxTalents = 5;

class TalentsScreen extends ConsumerStatefulWidget {
  const TalentsScreen({super.key});

  @override
  ConsumerState<TalentsScreen> createState() => _TalentsScreenState();
}

class _TalentsScreenState extends ConsumerState<TalentsScreen> {
  /// Insertion order matters: the first pick is the main talent.
  final List<String> _picked = [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // Coming back to this screen keeps what was saved before.
    final session = ref.read(sessionProvider);
    if (session is SignedIn) {
      final talents = [...session.me.talents]
        ..sort((a, b) => (b.isPrimary ? 1 : 0) - (a.isPrimary ? 1 : 0));
      _picked.addAll(talents.map((talent) => talent.categoryId));
    }
  }

  void _toggle(String id) {
    setState(() {
      if (_picked.contains(id)) {
        _picked.remove(id);
      } else if (_picked.length < maxTalents) {
        _picked.add(id);
      } else {
        unawaited(HapticFeedback.heavyImpact());
      }
    });
  }

  void _makeMain(String id) {
    setState(
      () => _picked
        ..remove(id)
        ..insert(0, id),
    );
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(onboardingControllerProvider)
          .saveTalents(categoryIds: List.of(_picked));
      // Move on explicitly: people who finished onboarding may come back here
      // to edit, so the router does not push them forward on its own.
      if (mounted) context.go(Routes.profile);
    } on ApiFailure catch (failure) {
      if (mounted) {
        TalantaSnack.show(
          context,
          failure.message(AppLocalizations.of(context)),
          error: true,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(talentCategoriesProvider);

    return OnboardingScaffold(
      step: 3,
      title: l10n.talentsTitle,
      subtitle: l10n.talentsSubtitle(maxTalents),
      scrollable: false,
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _LoadError(
          message: error is ApiFailure
              ? error.message(l10n)
              : l10n.talentsLoadFailed,
          onRetry: () => ref.invalidate(talentCategoriesProvider),
        ),
        data: (list) => GridView.builder(
          key: const ValueKey('talents-grid'),
          padding: const EdgeInsets.only(bottom: TalantaSpacing.x4),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            mainAxisSpacing: TalantaSpacing.x3,
            crossAxisSpacing: TalantaSpacing.x3,
            childAspectRatio: 1.6,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final category = list[index];
            final selected = _picked.contains(category.id);
            return _TalentTile(
              category: category,
              selected: selected,
              isMain: _picked.firstOrNull == category.id,
              mainLabel: l10n.talentsMain,
              onTap: _busy ? null : () => _toggle(category.id),
              onMakeMain: selected && !_busy
                  ? () => _makeMain(category.id)
                  : null,
            );
          },
        ),
      ),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.talentsSelectedCount(_picked.length),
            key: const ValueKey('talents-count'),
            textAlign: TextAlign.center,
            style: context.text.bodySmall?.copyWith(
              color: context.palette.textMuted,
            ),
          ),
          const SizedBox(height: TalantaSpacing.x2),
          TalantaButton(
            key: const ValueKey('save-talents'),
            label: l10n.continueLabel,
            busy: _busy,
            onPressed: _picked.isEmpty ? null : _save,
          ),
        ],
      ),
    );
  }
}

class _TalentTile extends StatelessWidget {
  const _TalentTile({
    required this.category,
    required this.selected,
    required this.isMain,
    required this.mainLabel,
    required this.onTap,
    required this.onMakeMain,
  });

  final TalentCategory category;
  final bool selected;
  final bool isMain;
  final String mainLabel;
  final VoidCallback? onTap;
  final VoidCallback? onMakeMain;

  @override
  Widget build(BuildContext context) {
    final name = TalentNames.of(
      AppLocalizations.of(context),
      category.slug,
      category.name,
    );
    final palette = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: name,
      child: TalantaCard(
        key: ValueKey('talent-${category.slug}'),
        raised: selected,
        borderColor: selected ? TalantaBrand.primary : null,
        padding: const EdgeInsets.all(TalantaSpacing.x3),
        onTap: onTap == null
            ? null
            : () {
                unawaited(HapticFeedback.selectionClick());
                onTap!();
              },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: TalantaDurations.fast,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected
                        ? TalantaBrand.primary
                        : palette.surfaceRaised,
                    borderRadius: BorderRadius.circular(TalantaRadii.sm),
                  ),
                  child: Icon(
                    TalentIcons.of(category.icon),
                    color: selected ? palette.onPrimary : palette.textMuted,
                    size: 22,
                  ),
                ),
                const Spacer(),
                if (isMain)
                  _MainBadge(label: mainLabel)
                else if (selected)
                  IconButton(
                    key: ValueKey('make-main-${category.slug}'),
                    tooltip: mainLabel,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.star_outline_rounded,
                      color: palette.textMuted,
                    ),
                    onPressed: onMakeMain,
                  ),
              ],
            ),
            const Spacer(),
            Text(name, style: context.text.titleMedium, maxLines: 2),
          ],
        ),
      ),
    );
  }
}

class _MainBadge extends StatelessWidget {
  const _MainBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TalantaSpacing.x2,
        vertical: TalantaSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: TalantaBrand.gold,
        borderRadius: BorderRadius.circular(TalantaRadii.pill),
      ),
      child: Text(
        label,
        style: context.text.labelSmall?.copyWith(
          color: context.palette.onPrimary,
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: TalantaSpacing.x4),
          TalantaButton(
            label: AppLocalizations.of(context).retry,
            variant: TalantaButtonVariant.secondary,
            expand: false,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
