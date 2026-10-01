import 'package:catbreeds/core/theme/app_colors_extension.dart';
import 'package:catbreeds/core/theme/app_spacing.dart';
import 'package:catbreeds/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Para escribir `context.colors.accent` en vez de buscar el tema a mano
/// en cada widget.
extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  /// Los colores de la app por su uso (fondo, texto, acento...).
  AppColorsExtension get colors => theme.extension<AppColorsExtension>()!;

  AppTypography get typography => const AppTypography();

  AppSpacing get spacing => const AppSpacing();

  AppRadius get radius => const AppRadius();

  /// En iOS y macOS pintamos controles Cupertino; en el resto, Material.
  bool get isCupertino => switch (theme.platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => true,
    _ => false,
  };
}
