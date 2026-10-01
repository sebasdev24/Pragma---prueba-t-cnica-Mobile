import 'package:flutter/material.dart';

/// Los colores tal cual están en el Figma (colección Color · Light).
///
/// Ninguna vista los usa directamente: siempre pasan por
/// [AppColorsExtension], que les da un nombre según su uso.
class AppPalette {
  const AppPalette._();

  // Papel (claro)
  static const paper50 = Color(0xFFFFFFFF);
  static const paper100 = Color(0xFFF5F1EA);
  static const paper200 = Color(0xFFECE6DC);
  static const paper300 = Color(0xFFE4DDD2);
  static const paper400 = Color(0xFFCFC6B9);

  // Tinta (texto)
  static const ink900 = Color(0xFF1A1613);
  static const ink700 = Color(0xFF6B625A);
  static const ink500 = Color(0xFF9C9389);

  // Terracota (acento)
  static const terracotta500 = Color(0xFFC8502A);
  static const terracotta100 = Color(0xFFF6E2D6);

  // Error
  static const red600 = Color(0xFFB3261E);
  static const red100 = Color(0xFFF9DEDC);
}
