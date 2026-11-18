import 'package:flutter/material.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/talanta_button.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// What a list shows when there is nothing in it yet: never a blank screen.
class TalantaEmptyState extends StatelessWidget {
  const TalantaEmptyState({
    required this.icon,
    required this.title,
    super.key,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TalantaSpacing.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: palette.surfaceRaised,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: palette.textMuted, size: 28),
            ),
            const SizedBox(height: TalantaSpacing.x4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.text.titleMedium,
            ),
            if (body != null) ...[
              const SizedBox(height: TalantaSpacing.x2),
              Text(
                body!,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(
                  color: palette.textMuted,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: TalantaSpacing.x5),
              TalantaButton(
                label: actionLabel!,
                expand: false,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A failed load, in words people understand, with a retry.
class TalantaErrorState extends StatelessWidget {
  const TalantaErrorState({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failure = ApiFailure.from(error);
    return TalantaEmptyState(
      icon: failure is OfflineFailure
          ? Icons.wifi_off_rounded
          : Icons.error_outline_rounded,
      title: failure.message(l10n),
      actionLabel: l10n.retry,
      onAction: onRetry,
    );
  }
}

/// A small rounded label: status, compensation, featured...
class TalantaTag extends StatelessWidget {
  const TalantaTag({
    required this.label,
    super.key,
    this.icon,
    this.color,
    this.filled = false,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tone = color ?? palette.textMuted;
    final foreground = filled ? palette.onPrimary : tone;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TalantaSpacing.x2,
        vertical: TalantaSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: filled ? tone : tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(TalantaRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: TalantaSpacing.x1),
          ],
          Text(
            label,
            style: context.text.labelSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
