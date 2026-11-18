import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Account, safety and sign-out, grouped the way people look for them.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l10n.deleteTitle),
        content: Text(l10n.deleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const ValueKey('confirm-delete'),
            onPressed: () => Navigator.pop(dialog, true),
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

  Future<void> _safetyTips(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            TalantaSpacing.x5,
            0,
            TalantaSpacing.x5,
            TalantaSpacing.x5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.safetyTitle, style: context.text.headlineSmall),
              const SizedBox(height: TalantaSpacing.x4),
              for (final tip in [
                l10n.safetyTipPay,
                l10n.safetyTipMeet,
                l10n.safetyTipMinors,
                l10n.safetyTipReport,
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: TalantaSpacing.x3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF4CC48A),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: TalantaSpacing.x3),
                      Expanded(
                        child: Text(tip, style: context.text.bodyMedium),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    final me = session is SignedIn ? session.me : null;

    return Scaffold(
      key: const ValueKey('settings-screen'),
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          TalantaSpacing.x4,
          TalantaSpacing.x2,
          TalantaSpacing.x4,
          TalantaSpacing.x10,
        ),
        children: [
          if (me?.profile case final profile?)
            _Group(
              children: [
                ListTile(
                  key: const ValueKey('settings-profile'),
                  leading: TalantaAvatar(
                    name: profile.displayName,
                    imageUrl: profile.avatarUrl,
                  ),
                  title: Text(
                    profile.displayName,
                    style: context.text.titleMedium,
                  ),
                  subtitle: Text(
                    '@${profile.username}',
                    style: context.text.bodySmall?.copyWith(
                      color: context.palette.textMuted,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => unawaited(context.push(Routes.me)),
                ),
              ],
            ),
          _Heading(l10n.settingsAccount),
          _Group(
            children: [
              _Row(
                key: const ValueKey('menu-edit-profile'),
                icon: Icons.edit_outlined,
                label: l10n.profileMenuEdit,
                onTap: () => unawaited(context.push(Routes.editProfile)),
              ),
              _Row(
                icon: Icons.auto_awesome_outlined,
                label: l10n.profileMenuTalents,
                onTap: () => unawaited(context.push(Routes.talents)),
              ),
              _Row(
                key: const ValueKey('menu-my-calls'),
                icon: Icons.work_outline_rounded,
                label: l10n.profileMenuCalls,
                onTap: () => unawaited(context.push(Routes.myCalls)),
              ),
            ],
          ),
          _Heading(l10n.settingsSafety),
          _Group(
            children: [
              _Row(
                key: const ValueKey('menu-safety'),
                icon: Icons.shield_outlined,
                label: l10n.safetyTitle,
                onTap: () => unawaited(_safetyTips(context)),
              ),
              _Row(
                icon: Icons.notifications_none_rounded,
                label: l10n.navActivity,
                onTap: () => unawaited(context.push(Routes.activity)),
              ),
            ],
          ),
          _Heading(l10n.settingsApp),
          _Group(
            children: [
              _Row(
                icon: Icons.translate_rounded,
                label: l10n.settingsLanguage,
                value: l10n.settingsLanguageValue,
              ),
              _Row(
                icon: Icons.info_outline_rounded,
                label: l10n.settingsAbout,
                value: 'Talanta 0.1',
              ),
            ],
          ),
          const SizedBox(height: TalantaSpacing.x5),
          _Group(
            children: [
              _Row(
                key: const ValueKey('sign-out'),
                icon: Icons.logout_rounded,
                label: l10n.homeSignOut,
                danger: true,
                onTap: () =>
                    unawaited(ref.read(sessionProvider.notifier).signOut()),
              ),
              _Row(
                key: const ValueKey('delete-account'),
                icon: Icons.delete_forever_outlined,
                label: l10n.profileMenuDelete,
                danger: true,
                onTap: () => unawaited(_deleteAccount(context, ref)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TalantaSpacing.x1,
        TalantaSpacing.x5,
        0,
        TalantaSpacing.x2,
      ),
      child: Text(
        text.toUpperCase(),
        style: context.text.labelSmall?.copyWith(
          color: context.palette.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(TalantaRadii.md),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, indent: 52, color: palette.outline),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    super.key,
    this.value,
    this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = danger ? palette.danger : palette.text;
    return ListTile(
      leading: Icon(
        icon,
        color: danger ? palette.danger : palette.textSecondary,
      ),
      title: Text(label, style: context.text.bodyLarge?.copyWith(color: color)),
      trailing: value != null
          ? ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Text(
                value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: context.text.bodyMedium?.copyWith(
                  color: palette.textMuted,
                ),
              ),
            )
          : onTap == null || danger
          ? null
          : Icon(Icons.chevron_right_rounded, color: palette.textMuted),
      onTap: onTap,
    );
  }
}
