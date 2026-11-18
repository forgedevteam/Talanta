import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Shown while stored tokens are checked. The wordmark stands in for the
/// logo until the brand work lands.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: TalantaDurations.slow * 2,
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  late final Animation<Offset> _rise = Tween(
    begin: const Offset(0, 0.08),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unreachable = ref.watch(sessionProvider) is SessionUnreachable;
    return Scaffold(
      body: PatternBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _rise,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SignatureGradient(
                    child: Text(
                      l10n.appName,
                      style: context.text.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 56,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(height: TalantaSpacing.x3),
                  Text(
                    l10n.splashTagline,
                    style: context.text.titleMedium?.copyWith(
                      color: context.palette.textMuted,
                    ),
                  ),
                  if (unreachable) ...[
                    const SizedBox(height: TalantaSpacing.x10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TalantaSpacing.x8,
                      ),
                      child: Text(
                        l10n.errorOffline,
                        key: const ValueKey('splash-offline'),
                        textAlign: TextAlign.center,
                        style: context.text.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: TalantaSpacing.x4),
                    TalantaButton(
                      key: const ValueKey('splash-retry'),
                      label: l10n.retry,
                      variant: TalantaButtonVariant.secondary,
                      expand: false,
                      onPressed: () =>
                          ref.read(sessionProvider.notifier).retry(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
