import 'package:catbreeds/core/constants/app_fonts.dart';
import 'package:catbreeds/core/theme/app_colors_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Solo existe el tema claro para fines de la prueba
class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const c = AppColorsExtension.light;
    const brightness = Brightness.light;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.accent,
      onPrimary: c.onAccent,
      secondary: c.accent,
      onSecondary: c.onAccent,
      error: c.danger,
      onError: c.onAccent,
      surface: c.background,
      onSurface: c.foreground,
      surfaceContainerHighest: c.sunken,
      outline: c.borderStrong,
      outlineVariant: c.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      fontFamily: AppFonts.system,
      splashFactory: InkSparkle.splashFactory,
      extensions: const [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.foreground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.system,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: c.foreground,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.accent),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.accent,
        selectionColor: c.accent.withValues(alpha: 0.25),
        selectionHandleColor: c.accent,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: c.accent,
        scaffoldBackgroundColor: c.background,
      ),
    );
  }
}
