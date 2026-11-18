// GENERATED FILE — do not edit. Source: packages/design-tokens/tokens.json
// ignore_for_file: public_member_api_docs

import 'dart:ui';

/// Brand colours that stay the same in dark and light mode.
abstract final class TalantaBrand {
  static const Color primary = Color(0xFFFF6B2C);
  static const Color secondary = Color(0xFF6C2BD9);
  static const Color gold = Color(0xFFF5B700);

  /// Sunset Orange to Deep Violet. Reserved for the logo, splash and record button.
  static const List<Color> signatureGradient = [
    Color(0xFFFF6B2C),
    Color(0xFF6C2BD9),
  ];
}

/// Mode-dependent colour roles.
final class TalantaPalette {
  const TalantaPalette({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.outline,
    required this.outlineStrong,
    required this.text,
    required this.textSecondary,
    required this.textMuted,
    required this.onPrimary,
    required this.success,
    required this.danger,
  });

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color outline;
  final Color outlineStrong;
  final Color text;
  final Color textSecondary;
  final Color textMuted;
  final Color onPrimary;
  final Color success;
  final Color danger;

  static const TalantaPalette dark = TalantaPalette(
    background: Color(0xFF0E0B14),
    surface: Color(0xFF1A1622),
    surfaceRaised: Color(0xFF221C2C),
    outline: Color(0xFF241F2E),
    outlineStrong: Color(0xFF3A3346),
    text: Color(0xFFF7F5FA),
    textSecondary: Color(0xFFC9C3D6),
    textMuted: Color(0xFFA59FB3),
    onPrimary: Color(0xFF1A0E06),
    success: Color(0xFF2EBD7A),
    danger: Color(0xFFE5484D),
  );

  static const TalantaPalette light = TalantaPalette(
    background: Color(0xFFFAF7F2),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFF2EDE6),
    outline: Color(0xFFE2DBD0),
    outlineStrong: Color(0xFFCFC6B8),
    text: Color(0xFF17121F),
    textSecondary: Color(0xFF3D3548),
    textMuted: Color(0xFF6B647A),
    onPrimary: Color(0xFF1A0E06),
    success: Color(0xFF1E9E55),
    danger: Color(0xFFD93A40),
  );
}

abstract final class TalantaRadii {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 999;
}

/// Spacing scale of 4. `x4` is 16 logical pixels.
abstract final class TalantaSpacing {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;
  static const double x12 = 48;
  static const double x16 = 64;
}

abstract final class TalantaDurations {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 360);
}

abstract final class TalantaFonts {
  static const String display = 'BricolageGrotesque';
  static const String body = 'Inter';
}
