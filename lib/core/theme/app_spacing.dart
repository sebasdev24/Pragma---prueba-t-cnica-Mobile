import 'package:flutter/widgets.dart';

/// Escala de espaciado (colección Dimension de Figma). Sin números mágicos:
/// todo margen, padding y gap sale de aquí vía `context.spacing.*`.
class AppSpacing {
  const AppSpacing();

  /// 2
  double get sx => 2;

  /// 4
  double get sm => 4;

  /// 8
  double get base => 8;

  /// 12
  double get md => 12;

  /// 16 (margen lateral de pantalla)
  double get lg => 16;

  /// 24
  double get xl => 24;

  /// 32
  double get xl2 => 32;

  /// 56
  double get safe => 56;

  /// Padding horizontal estándar de pantalla.
  EdgeInsets get screen => EdgeInsets.symmetric(horizontal: lg);
}

/// Radios de esquina.
class AppRadius {
  const AppRadius();

  /// 6 · badges
  double get xs => 6;

  /// 14 · campos, fotos dentro de cards
  double get md => 14;

  /// 20 · stat tiles
  double get lg => 20;

  /// 24 · cards
  double get xl => 24;

  /// 28 · foto del detalle
  double get xl2 => 28;

  /// pills
  double get full => 999;
}
