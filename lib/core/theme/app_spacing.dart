import 'package:flutter/widgets.dart';

/// La escala de espacios del Figma. Cualquier margen,
/// padding o separación sale de aquí con `context.spacing.*`, para no
/// tener números sueltos por las vistas.
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

  /// El margen lateral que llevan todas las pantallas.
  EdgeInsets get screen => EdgeInsets.symmetric(horizontal: lg);
}

/// Bordes.
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
