import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/features/activity/application/activity_providers.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// The four tabs. Keeps each tab's scroll position and refreshes the
/// Activity badge when the app comes back to the front.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell>
    with WidgetsBindingObserver {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _poll = Timer.periodic(
      const Duration(minutes: 2),
      (_) => ref.invalidate(unreadCountProvider),
    );
  }

  @override
  void dispose() {
    _poll?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ref.invalidate(unreadCountProvider);
  }

  void _go(int index) {
    if (index == 2) ref.invalidate(unreadCountProvider);
    widget.shell.goBranch(
      index,
      initialLocation: index == widget.shell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final unread = ref.watch(unreadCountProvider).value ?? 0;

    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: palette.surface,
          indicatorColor: TalantaBrand.primary.withValues(alpha: 0.18),
          labelTextStyle: WidgetStatePropertyAll(context.text.labelSmall),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? TalantaBrand.primary
                  : palette.textMuted,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: widget.shell.currentIndex,
          onDestinationSelected: _go,
          destinations: [
            NavigationDestination(
              key: const ValueKey('nav-calls'),
              icon: const Icon(Icons.campaign_outlined),
              selectedIcon: const Icon(Icons.campaign_rounded),
              label: l10n.navCalls,
            ),
            NavigationDestination(
              key: const ValueKey('nav-discover'),
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore_rounded),
              label: l10n.navDiscover,
            ),
            NavigationDestination(
              key: const ValueKey('nav-activity'),
              icon: Badge(
                isLabelVisible: unread > 0,
                label: Text(unread > 9 ? '9+' : '$unread'),
                backgroundColor: TalantaBrand.primary,
                child: const Icon(Icons.notifications_none_rounded),
              ),
              selectedIcon: const Icon(Icons.notifications_rounded),
              label: l10n.navActivity,
            ),
            NavigationDestination(
              key: const ValueKey('nav-me'),
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
