import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

enum TalantaButtonVariant { primary, secondary, ghost }

/// The one button. Full width by default, shows its own spinner while busy,
/// and gives a light tap on press.
class TalantaButton extends StatelessWidget {
  const TalantaButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = TalantaButtonVariant.primary,
    this.busy = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final TalantaButtonVariant variant;
  final bool busy;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    void handlePress() {
      unawaited(HapticFeedback.lightImpact());
      onPressed?.call();
    }

    final child = AnimatedSwitcher(
      duration: TalantaDurations.fast,
      child: busy
          ? SizedBox(
              key: const ValueKey('busy'),
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: variant == TalantaButtonVariant.primary
                    ? context.palette.onPrimary
                    : TalantaBrand.primary,
              ),
            )
          : Row(
              key: const ValueKey('label'),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: TalantaSpacing.x2),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );

    final button = switch (variant) {
      TalantaButtonVariant.primary => FilledButton(
        onPressed: enabled ? handlePress : null,
        child: child,
      ),
      TalantaButtonVariant.secondary => OutlinedButton(
        onPressed: enabled ? handlePress : null,
        child: child,
      ),
      TalantaButtonVariant.ghost => TextButton(
        onPressed: enabled ? handlePress : null,
        child: child,
      ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
