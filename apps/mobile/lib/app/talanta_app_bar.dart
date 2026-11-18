import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/activity/application/activity_providers.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// The wordmark, set in the display face.
class TalantaWordmark extends StatelessWidget {
  const TalantaWordmark({super.key, this.size = 26});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'talanta',
      style: context.text.headlineMedium?.copyWith(
        color: TalantaBrand.primary,
        fontSize: size,
        height: 1,
      ),
    );
  }
}

/// The bar at the top of every main screen: my picture on the left (my
/// profile), then the title, then notifications and settings on the right.
class TalantaAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const TalantaAppBar({super.key, this.title, this.actions = const []});

  /// Shows the wordmark when null.
  final String? title;

  /// Extra buttons, placed before notifications and settings.
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    final profile = session is SignedIn ? session.me.profile : null;
    final unread = ref.watch(unreadCountProvider).value ?? 0;

    return AppBar(
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      titleSpacing: TalantaSpacing.x4,
      title: Row(
        children: [
          Semantics(
            button: true,
            label: l10n.openMyProfile,
            child: GestureDetector(
              key: const ValueKey('my-avatar'),
              onTap: () => unawaited(context.push(Routes.me)),
              child: TalantaAvatar(
                name: profile?.displayName ?? '',
                imageUrl: profile?.avatarUrl,
                size: 36,
              ),
            ),
          ),
          const SizedBox(width: TalantaSpacing.x3),
          Flexible(
            child: title == null
                ? const TalantaWordmark()
                : Text(
                    title!,
                    style: context.text.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
      actions: [
        ...actions,
        IconButton(
          key: const ValueKey('open-activity'),
          tooltip: l10n.navActivity,
          onPressed: () {
            ref.invalidate(unreadCountProvider);
            unawaited(context.push(Routes.activity));
          },
          icon: Badge(
            isLabelVisible: unread > 0,
            label: Text(unread > 9 ? '9+' : '$unread'),
            backgroundColor: TalantaBrand.primary,
            textColor: context.palette.onPrimary,
            child: const Icon(Icons.notifications_none_rounded),
          ),
        ),
        IconButton(
          key: const ValueKey('open-settings'),
          tooltip: l10n.settingsTitle,
          onPressed: () => unawaited(context.push(Routes.settings)),
          icon: const Icon(Icons.settings_outlined),
        ),
        const SizedBox(width: TalantaSpacing.x2),
      ],
    );
  }
}
