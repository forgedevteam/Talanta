import 'package:flutter/material.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Clash Display for headlines, Inter for everything else. Both fonts are
/// variable, so each style sets the weight axis as well as [FontWeight].
abstract final class TalantaTypography {
  static TextStyle _display(
    double size,
    double weight, {
    double? height,
    double? spacing,
  }) => TextStyle(
    fontFamily: TalantaFonts.display,
    fontSize: size,
    fontWeight: _weight(weight),
    fontVariations: [FontVariation.weight(weight)],
    height: height,
    letterSpacing: spacing,
  );

  static TextStyle _body(
    double size,
    double weight, {
    double? height,
    double? spacing,
  }) => TextStyle(
    fontFamily: TalantaFonts.body,
    fontSize: size,
    fontWeight: _weight(weight),
    fontVariations: [FontVariation.weight(weight)],
    height: height,
    letterSpacing: spacing,
  );

  static FontWeight _weight(double weight) =>
      FontWeight.values[((weight / 100).round() - 1).clamp(0, 8)];

  static TextTheme textTheme(TalantaPalette palette) {
    final base = TextTheme(
      displayLarge: _display(44, 600, height: 1.05, spacing: -0.5),
      displayMedium: _display(36, 600, height: 1.1, spacing: -0.4),
      displaySmall: _display(30, 600, height: 1.15, spacing: -0.3),
      headlineLarge: _display(28, 600, height: 1.2, spacing: -0.2),
      headlineMedium: _display(24, 600, height: 1.2),
      headlineSmall: _display(20, 600, height: 1.25),
      titleLarge: _body(18, 600, height: 1.3),
      titleMedium: _body(16, 600, height: 1.35),
      titleSmall: _body(14, 600, height: 1.4),
      bodyLarge: _body(16, 400, height: 1.5),
      bodyMedium: _body(14, 400, height: 1.5),
      bodySmall: _body(12, 400, height: 1.45),
      labelLarge: _body(16, 600, height: 1.25, spacing: 0.1),
      labelMedium: _body(13, 600, height: 1.3, spacing: 0.2),
      labelSmall: _body(11, 600, height: 1.3, spacing: 0.4),
    );
    return base.apply(bodyColor: palette.text, displayColor: palette.text);
  }
}
