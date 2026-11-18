import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Where onboarding lands. The feed arrives in Phase 1.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final session = ref.watch(sessionProvider);
    final me = session is SignedIn ? session.me : null;
    final name = me?.profile?.displayName ?? '';

    return Scaffold(
      body: PatternBackground(
        opacity: 0.04,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(TalantaSpacing.x5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeWelcome(name),
                  key: const ValueKey('home-welcome'),
                  style: context.text.headlineLarge,
                ),
                if (me?.profile != null) ...[
                  const SizedBox(height: TalantaSpacing.x1),
                  Text(
                    '@${me!.profile!.username} · ${me.profile!.city ?? ''}',
                    style: context.text.bodyMedium?.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: TalantaSpacing.x6),
                Wrap(
                  spacing: TalantaSpacing.x2,
                  runSpacing: TalantaSpacing.x2,
                  children: [
                    for (final talent in me?.talents ?? const <UserTalent>[])
                      TalantaChip(
                        label: talent.name,
                        icon: TalentIcons.of(talent.icon),
                        selected: talent.isPrimary,
                        onTap: null,
                      ),
                  ],
                ),
                const SizedBox(height: TalantaSpacing.x8),
                TalantaCard(
                  child: Text(
                    l10n.homeComingSoon,
                    style: context.text.bodyLarge,
                  ),
                ),
                const Spacer(),
                TalantaButton(
                  key: const ValueKey('sign-out'),
                  label: l10n.homeSignOut,
                  variant: TalantaButtonVariant.secondary,
                  onPressed: () => ref.read(sessionProvider.notifier).signOut(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
