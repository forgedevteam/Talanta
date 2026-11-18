import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// A selectable pill. Selection fills it with the brand orange.
class TalantaChip extends StatelessWidget {
  const TalantaChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = selected ? palette.onPrimary : palette.text;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap == null
              ? null
              : () {
                  unawaited(HapticFeedback.selectionClick());
                  onTap!();
                },
          borderRadius: BorderRadius.circular(TalantaRadii.pill),
          child: AnimatedContainer(
            duration: TalantaDurations.fast,
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: TalantaSpacing.x4,
              vertical: TalantaSpacing.x3,
            ),
            decoration: BoxDecoration(
              color: selected ? TalantaBrand.primary : palette.surface,
              borderRadius: BorderRadius.circular(TalantaRadii.pill),
              border: Border.all(
                color: selected ? TalantaBrand.primary : palette.outline,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: foreground),
                  const SizedBox(width: TalantaSpacing.x2),
                ],
                Text(
                  label,
                  style: context.text.labelMedium?.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
