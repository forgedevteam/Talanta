import 'package:flutter/material.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Short status messages, one at a time.
abstract final class TalantaSnack {
  static void show(BuildContext context, String message, {bool error = false}) {
    final palette = context.palette;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                error
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: error ? palette.danger : palette.success,
                size: 20,
              ),
              const SizedBox(width: TalantaSpacing.x3),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
