import 'package:flutter/material.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Shown while stored tokens are checked. The wordmark stands in for the
/// logo until the brand work lands.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
