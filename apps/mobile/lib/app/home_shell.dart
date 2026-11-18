import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/features/activity/application/activity_providers.dart';
import 'package:talanta/features/posts/presentation/create_sheet.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Home, Reels, create, Calls, Discover. Keeps each tab's scroll position
/// and refreshes the notification badge when the app comes back.
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

  void _go(int branch) {
    unawaited(HapticFeedback.selectionClick());
    widget.shell.goBranch(
      branch,
      initialLocation: branch == widget.shell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = widget.shell.currentIndex;
    // Reels plays edge to edge, so its bar goes dark like the video.
    final immersive = current == 1;

    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: _BottomBar(
        immersive: immersive,
        children: [
          _Tab(
            key: const ValueKey('nav-home'),
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: l10n.navHome,
            active: current == 0,
            onTap: () => _go(0),
          ),
          _Tab(
            key: const ValueKey('nav-reels'),
            icon: Icons.smart_display_outlined,
            activeIcon: Icons.smart_display_rounded,
            label: l10n.navReels,
            active: current == 1,
            onTap: () => _go(1),
          ),
          _CreateButton(
            label: l10n.createTitle,
            onTap: () => unawaited(showCreateSheet(context)),
          ),
          _Tab(
            key: const ValueKey('nav-calls'),
            icon: Icons.work_outline_rounded,
            activeIcon: Icons.work_rounded,
            label: l10n.navCalls,
            active: current == 2,
            onTap: () => _go(2),
          ),
          _Tab(
            key: const ValueKey('nav-discover'),
            icon: Icons.explore_outlined,
            activeIcon: Icons.explore_rounded,
            label: l10n.navDiscover,
            active: current == 3,
            onTap: () => _go(3),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.children, required this.immersive});

  final List<Widget> children;
  final bool immersive;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: immersive ? Colors.black : const Color(0xFF120F19),
        border: Border(top: BorderSide(color: palette.outline)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [for (final child in children) Expanded(child: child)],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? TalantaBrand.primary : context.palette.textMuted;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? activeIcon : icon, color: color, size: 25),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: GestureDetector(
          key: const ValueKey('nav-create'),
          onTap: () {
            unawaited(HapticFeedback.mediumImpact());
            onTap();
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: TalantaBrand.signatureGradient,
              ),
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
