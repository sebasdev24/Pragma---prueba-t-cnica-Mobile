import 'package:catbreeds/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Los colores con nombre de uso (`background`, `accent`...). Son los que
/// usan las vistas, con `context.colors.*`, y se llaman igual que las
/// variables del Figma.
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  /// bg/canvas
  final Color background;

  /// bg/surface: cards y tiles.
  final Color surface;

  /// bg/sunken: campos, placeholders, skeletons.
  final Color sunken;

  /// text/primary
  final Color foreground;

  /// text/secondary
  final Color foregroundMuted;

  /// text/tertiary: rótulos y placeholders.
  final Color foregroundSubtle;

  /// border/subtle
  final Color border;

  /// border/strong
  final Color borderStrong;

  /// accent/default
  final Color accent;

  /// accent/soft
  final Color accentSoft;

  /// accent/on: texto/íconos sobre [accent].
  final Color onAccent;

  /// feedback/danger
  final Color danger;

  /// feedback/danger-soft
  final Color dangerSoft;

  const AppColorsExtension({
    required this.background,
    required this.surface,
    required this.sunken,
    required this.foreground,
    required this.foregroundMuted,
    required this.foregroundSubtle,
    required this.border,
    required this.borderStrong,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.danger,
    required this.dangerSoft,
  });

  static const light = AppColorsExtension(
    background: AppPalette.paper100,
    surface: AppPalette.paper50,
    sunken: AppPalette.paper200,
    foreground: AppPalette.ink900,
    foregroundMuted: AppPalette.ink700,
    foregroundSubtle: AppPalette.ink500,
    border: AppPalette.paper300,
    borderStrong: AppPalette.paper400,
    accent: AppPalette.terracotta500,
    accentSoft: AppPalette.terracotta100,
    onAccent: AppPalette.paper50,
    danger: AppPalette.red600,
    dangerSoft: AppPalette.red100,
  );

  @override
  AppColorsExtension copyWith({
    Color? background,
    Color? surface,
    Color? sunken,
    Color? foreground,
    Color? foregroundMuted,
    Color? foregroundSubtle,
    Color? border,
    Color? borderStrong,
    Color? accent,
    Color? accentSoft,
    Color? onAccent,
    Color? danger,
    Color? dangerSoft,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      sunken: sunken ?? this.sunken,
      foreground: foreground ?? this.foreground,
      foregroundMuted: foregroundMuted ?? this.foregroundMuted,
      foregroundSubtle: foregroundSubtle ?? this.foregroundSubtle,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      onAccent: onAccent ?? this.onAccent,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColorsExtension(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      sunken: l(sunken, other.sunken),
      foreground: l(foreground, other.foreground),
      foregroundMuted: l(foregroundMuted, other.foregroundMuted),
      foregroundSubtle: l(foregroundSubtle, other.foregroundSubtle),
      border: l(border, other.border),
      borderStrong: l(borderStrong, other.borderStrong),
      accent: l(accent, other.accent),
      accentSoft: l(accentSoft, other.accentSoft),
      onAccent: l(onAccent, other.onAccent),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
    );
  }
}
