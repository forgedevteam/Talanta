import 'package:flutter/material.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Bricolage Grotesque for headlines, Inter for everything else. Both fonts
/// are variable, so each style sets the weight axis as well as [FontWeight].
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
      // Tight tracking at display sizes is what gives Bricolage its voice.
      displayLarge: _display(44, 800, height: 1.02, spacing: -1.1),
      displayMedium: _display(38, 800, height: 1.05, spacing: -0.95),
      displaySmall: _display(30, 800, height: 1.1, spacing: -0.75),
      headlineLarge: _display(28, 800, height: 1.12, spacing: -0.7),
      headlineMedium: _display(24, 800, height: 1.15, spacing: -0.6),
      headlineSmall: _display(20, 700, height: 1.2, spacing: -0.4),
      titleLarge: _body(18, 700, height: 1.3, spacing: -0.2),
      titleMedium: _body(15.5, 700, height: 1.3, spacing: -0.1),
      titleSmall: _body(14, 600, height: 1.35),
      bodyLarge: _body(16, 400, height: 1.45),
      bodyMedium: _body(14.5, 400, height: 1.45),
      bodySmall: _body(12.5, 400, height: 1.4),
      labelLarge: _body(15.5, 700, height: 1.25),
      labelMedium: _body(13, 600, height: 1.3),
      labelSmall: _body(11.5, 600, height: 1.3, spacing: 0.3),
    );
    return base.apply(bodyColor: palette.text, displayColor: palette.text);
  }
}
