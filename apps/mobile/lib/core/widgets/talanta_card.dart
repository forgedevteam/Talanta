import 'package:flutter/material.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// A flat surface with the large radius. Raised cards sit one step lighter.
class TalantaCard extends StatelessWidget {
  const TalantaCard({
    required this.child,
    super.key,
    this.raised = false,
    this.padding = const EdgeInsets.all(TalantaSpacing.x4),
    this.onTap,
    this.borderColor,
  });

  final Widget child;
  final bool raised;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = BorderRadius.circular(TalantaRadii.lg);
    return Material(
      color: raised ? palette.surfaceRaised : palette.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: TalantaDurations.fast,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor ?? palette.outline),
          ),
          child: child,
        ),
      ),
    );
  }
}
