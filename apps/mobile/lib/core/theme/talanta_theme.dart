import 'package:flutter/material.dart';
import 'package:talanta/core/theme/talanta_typography.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Colour roles beyond what [ColorScheme] covers, read via `context.palette`.
@immutable
class TalantaColors extends ThemeExtension<TalantaColors> {
  const TalantaColors(this.palette);

  final TalantaPalette palette;

  Color get background => palette.background;
  Color get surface => palette.surface;
  Color get surfaceRaised => palette.surfaceRaised;
  Color get outline => palette.outline;
  Color get outlineStrong => palette.outlineStrong;
  Color get text => palette.text;
  Color get textSecondary => palette.textSecondary;
  Color get textMuted => palette.textMuted;
  Color get onPrimary => palette.onPrimary;
  Color get success => palette.success;
  Color get danger => palette.danger;

  @override
  TalantaColors copyWith({TalantaPalette? palette}) =>
      TalantaColors(palette ?? this.palette);

  @override
  TalantaColors lerp(TalantaColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return TalantaColors(
      TalantaPalette(
        background: mix(background, other.background),
        surface: mix(surface, other.surface),
        surfaceRaised: mix(surfaceRaised, other.surfaceRaised),
        outline: mix(outline, other.outline),
        outlineStrong: mix(outlineStrong, other.outlineStrong),
        text: mix(text, other.text),
        textSecondary: mix(textSecondary, other.textSecondary),
        textMuted: mix(textMuted, other.textMuted),
        onPrimary: mix(onPrimary, other.onPrimary),
        success: mix(success, other.success),
        danger: mix(danger, other.danger),
      ),
    );
  }
}

extension TalantaThemeContext on BuildContext {
  TalantaColors get palette => Theme.of(this).extension<TalantaColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
}

/// The app's own look: dark by default, flat surfaces, pill buttons, no
/// Material defaults showing through.
abstract final class TalantaTheme {
  static ThemeData dark() => _build(TalantaPalette.dark, Brightness.dark);

  static ThemeData light() => _build(TalantaPalette.light, Brightness.light);

  static ThemeData _build(TalantaPalette palette, Brightness brightness) {
    final colors = TalantaColors(palette);
    final textTheme = TalantaTypography.textTheme(palette);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: TalantaBrand.primary,
      onPrimary: palette.onPrimary,
      secondary: TalantaBrand.secondary,
      onSecondary: palette.text,
      tertiary: TalantaBrand.gold,
      onTertiary: palette.onPrimary,
      error: palette.danger,
      onError: palette.text,
      surface: palette.surface,
      onSurface: palette.text,
      onSurfaceVariant: palette.textMuted,
      outline: palette.outline,
      surfaceContainerHighest: palette.surfaceRaised,
    );

    const smallShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(TalantaRadii.sm)),
    );
    OutlineInputBorder inputBorder(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(TalantaRadii.sm),
          ),
          borderSide: BorderSide(color: color, width: width),
        );
    const pill = StadiumBorder();
    const largeShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(TalantaRadii.lg)),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      splashFactory: InkSparkle.splashFactory,
      textTheme: textTheme,
      fontFamily: TalantaFonts.body,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: largeShape,
      ),
      dividerTheme: DividerThemeData(
        color: palette.outline,
        space: 1,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TalantaSpacing.x4,
          vertical: TalantaSpacing.x4,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: palette.textMuted),
        labelStyle: textTheme.bodyMedium?.copyWith(color: palette.textMuted),
        helperStyle: textTheme.bodySmall?.copyWith(color: palette.textMuted),
        errorStyle: textTheme.bodySmall?.copyWith(color: palette.danger),
        border: inputBorder(palette.outline),
        enabledBorder: inputBorder(palette.outline),
        focusedBorder: inputBorder(TalantaBrand.primary, width: 1.5),
        errorBorder: inputBorder(palette.danger),
        focusedErrorBorder: inputBorder(palette.danger, width: 1.5),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: TalantaBrand.primary,
          foregroundColor: palette.onPrimary,
          disabledBackgroundColor: palette.surfaceRaised,
          disabledForegroundColor: palette.textMuted,
          minimumSize: const Size(64, 50),
          shape: pill,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.text,
          minimumSize: const Size(64, 50),
          shape: pill,
          side: BorderSide(color: palette.outlineStrong, width: 1.2),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: TalantaBrand.primary,
          textStyle: textTheme.labelLarge,
          shape: pill,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: palette.text),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surfaceRaised,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: palette.text),
        behavior: SnackBarBehavior.floating,
        shape: smallShape,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: palette.surface,
        headerBackgroundColor: palette.surfaceRaised,
        headerForegroundColor: palette.text,
        surfaceTintColor: Colors.transparent,
        shape: largeShape,
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? palette.onPrimary
              : palette.text,
        ),
        yearForegroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? palette.onPrimary
              : palette.text,
        ),
        todayForegroundColor: const WidgetStatePropertyAll(
          TalantaBrand.primary,
        ),
        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: palette.textMuted,
        ),
        confirmButtonStyle: TextButton.styleFrom(
          foregroundColor: TalantaBrand.primary,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        modalBackgroundColor: palette.surface,
        showDragHandle: true,
        dragHandleColor: palette.outline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TalantaRadii.lg),
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: TalantaBrand.primary,
      ),
      listTileTheme: ListTileThemeData(
        textColor: palette.text,
        iconColor: palette.textMuted,
        shape: smallShape,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
