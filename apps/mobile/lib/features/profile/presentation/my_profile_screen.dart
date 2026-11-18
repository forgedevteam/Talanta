import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/discover/application/discover_providers.dart';
import 'package:talanta/features/discover/presentation/creator_profile_view.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/features/profile/presentation/add_work_sheet.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    PortfolioItem piece,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.portfolioRemoveConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const ValueKey('confirm-remove'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(talantaActionsProvider).removePortfolioItem(piece.id);
    } on ApiFailure catch (failure) {
      if (context.mounted) {
        TalantaSnack.show(context, failure.message(l10n), error: true);
      }
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTitle),
        content: Text(l10n.deleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const ValueKey('confirm-delete'),
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: context.palette.danger,
            ),
            child: Text(l10n.deleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(talantaActionsProvider).deleteAccount();
    } on ApiFailure catch (failure) {
      if (context.mounted) {
        TalantaSnack.show(context, failure.message(l10n), error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    final username = session is SignedIn ? session.me.profile?.username : null;
    if (username == null) return const Scaffold();
    final profile = ref.watch(creatorProvider(username));

    final menu = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: TalantaSpacing.x6),
        _MenuItem(
          key: const ValueKey('menu-my-calls'),
          icon: Icons.campaign_outlined,
          label: l10n.profileMenuCalls,
          onTap: () => unawaited(context.push(Routes.myCalls)),
        ),
        _MenuItem(
          key: const ValueKey('menu-edit-profile'),
          icon: Icons.edit_outlined,
          label: l10n.profileMenuEdit,
          onTap: () => unawaited(context.push(Routes.profile)),
        ),
        _MenuItem(
          icon: Icons.auto_awesome_outlined,
          label: l10n.profileMenuTalents,
          onTap: () => unawaited(context.push(Routes.talents)),
        ),
        _MenuItem(
          key: const ValueKey('sign-out'),
          icon: Icons.logout_rounded,
          label: l10n.homeSignOut,
          onTap: () => unawaited(ref.read(sessionProvider.notifier).signOut()),
        ),
        _MenuItem(
          key: const ValueKey('delete-account'),
          icon: Icons.delete_forever_outlined,
          label: l10n.profileMenuDelete,
          danger: true,
          onTap: () => unawaited(_deleteAccount(context, ref)),
        ),
        const SizedBox(height: TalantaSpacing.x8),
      ],
    );

    return Scaffold(
      key: const ValueKey('me-screen'),
      body: SafeArea(
        bottom: false,
        child: profile.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => TalantaErrorState(
            error: error,
            onRetry: () => ref.invalidate(creatorProvider(username)),
          ),
          data: (p) => CreatorProfileView(
            profile: p,
            header: Padding(
              padding: const EdgeInsets.only(bottom: TalantaSpacing.x4),
              child: Text(l10n.navProfile, style: context.text.headlineLarge),
            ),
            onAddWork: () => unawaited(showAddWorkSheet(context)),
            onRemoveWork: (piece) => unawaited(_remove(context, ref, piece)),
            footer: menu,
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? context.palette.danger : context.palette.text;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: danger ? color : TalantaBrand.primary),
      title: Text(label, style: context.text.bodyLarge?.copyWith(color: color)),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: context.palette.textMuted,
      ),
      onTap: onTap,
    );
  }
}
