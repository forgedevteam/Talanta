import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Looks like `TalantaTextField` but opens a date picker. Shows the date day
/// first ("14 June 2001"), which reads naturally in every launch market.
class TalantaDateField extends StatelessWidget {
  const TalantaDateField({
    required this.label,
    required this.value,
    required this.onTap,
    super.key,
    this.hint,
    this.helper,
    this.error,
  });

  final String label;
  final DateTime? value;
  final VoidCallback? onTap;
  final String? hint;
  final String? helper;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final format = DateFormat(
      'd MMMM y',
      Localizations.localeOf(context).toLanguageTag(),
    );
    final message = error ?? helper;
    final borderColor = error != null ? palette.danger : palette.outline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.labelMedium?.copyWith(color: palette.textMuted),
        ),
        const SizedBox(height: TalantaSpacing.x2),
        Semantics(
          button: true,
          label: label,
          value: value == null ? null : format.format(value!),
          child: Material(
            color: palette.surface,
            borderRadius: BorderRadius.circular(TalantaRadii.sm),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(TalantaRadii.sm),
              child: Container(
                padding: const EdgeInsets.all(TalantaSpacing.x4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TalantaRadii.sm),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value == null ? (hint ?? '') : format.format(value!),
                        style: context.text.bodyLarge?.copyWith(
                          color: value == null
                              ? palette.textMuted
                              : palette.text,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: palette.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: TalantaSpacing.x2),
            child: Text(
              message,
              style: context.text.bodySmall?.copyWith(
                color: error == null ? palette.textMuted : palette.danger,
              ),
            ),
          ),
      ],
    );
  }
}
