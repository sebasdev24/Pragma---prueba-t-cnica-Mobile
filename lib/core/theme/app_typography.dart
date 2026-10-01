import 'package:catbreeds/core/constants/app_fonts.dart';
import 'package:flutter/material.dart';

/// Los estilos de texto del Figma: `display` (Fraunces) para títulos,
/// `system` (Geist) para el texto y los controles, y `mono.label` (Geist
/// Mono) para los rótulos en mayúsculas.
class AppTypography {
  const AppTypography();

  DisplayFont get display => const DisplayFont();
  SystemFont get system => const SystemFont();
  MonoFont get mono => const MonoFont();
}

class DisplayFont {
  const DisplayFont();

  static const _base = TextStyle(
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w600,
  );

  /// 44 · Display/XL (título grande de la lista, splash).
  TextStyle get xl =>
      _base.copyWith(fontSize: 44, height: 1.0, letterSpacing: -0.88);

  /// 34 · Display/L (nombre de la raza en el detalle).
  TextStyle get lg =>
      _base.copyWith(fontSize: 34, height: 1.05, letterSpacing: -0.51);

  /// 24 · Display/M (nombre en la card, títulos de estado).
  TextStyle get md =>
      _base.copyWith(fontSize: 24, height: 1.15, letterSpacing: -0.24);

  /// 18 a 20 · Display/Italic (los subtítulos en cursiva).
  TextStyle get italic => _base.copyWith(
    fontSize: 19,
    height: 1.3,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.1,
  );
}

class SystemFont {
  const SystemFont();

  static const _base = TextStyle(
    fontFamily: AppFonts.system,
    fontWeight: FontWeight.w400,
  );

  /// 17 · UI/Headline
  TextStyle get headline => _base.copyWith(
    fontSize: 17,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.17,
  );

  /// 16 · UI/Body
  TextStyle get body =>
      _base.copyWith(fontSize: 16, height: 1.5, letterSpacing: -0.08);

  /// 15 · UI/Callout
  TextStyle get callout => _base.copyWith(
    fontSize: 15,
    height: 1.35,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.08,
  );

  /// 14 · UI/Subhead
  TextStyle get subhead => _base.copyWith(fontSize: 14, height: 1.4);

  /// 12 · UI/Caption
  TextStyle get caption =>
      _base.copyWith(fontSize: 12, height: 1.3, fontWeight: FontWeight.w500);
}

class MonoFont {
  const MonoFont();

  /// 11 · Mono/Label
  TextStyle get label => const TextStyle(
    fontFamily: AppFonts.mono,
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 1.2,
    letterSpacing: 0.88,
  );
}
