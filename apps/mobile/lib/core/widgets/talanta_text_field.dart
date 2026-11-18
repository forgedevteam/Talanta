import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// A labelled input. The label sits above the field so it never moves, and
/// helper and error text share one slot so the layout does not jump.
class TalantaTextField extends StatelessWidget {
  const TalantaTextField({
    required this.label,
    super.key,
    this.controller,
    this.focusNode,
    this.hint,
    this.helper,
    this.error,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.autofocus = false,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final String? helper;
  final String? error;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool autofocus;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final message = error ?? helper;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.labelMedium?.copyWith(color: palette.textMuted),
        ),
        const SizedBox(height: TalantaSpacing.x2),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          minLines: minLines,
          maxLines: maxLines,
          autofocus: autofocus,
          enabled: enabled,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: context.text.bodyLarge,
          cursorColor: TalantaBrand.primary,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix,
            suffixIcon: suffix,
            counterText: '',
            // Errors are rendered below by hand so the border still turns red.
            errorText: error == null ? null : '',
            errorStyle: const TextStyle(height: 0, fontSize: 0),
          ),
        ),
        AnimatedSize(
          duration: TalantaDurations.fast,
          alignment: Alignment.topLeft,
          child: message == null
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: TalantaSpacing.x2),
                  child: Text(
                    message,
                    style: context.text.bodySmall?.copyWith(
                      color: error == null ? palette.textMuted : palette.danger,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
