import 'package:catbreeds/core/theme/app_colors_extension.dart';
import 'package:catbreeds/core/theme/app_spacing.dart';
import 'package:catbreeds/core/theme/app_typography.dart';
import 'package:catbreeds/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Atajos al sistema de diseño desde el `BuildContext`.
extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  /// Tokens de color semánticos.
  AppColorsExtension get colors => theme.extension<AppColorsExtension>()!;

  AppTypography get typography => const AppTypography();

  AppSpacing get spacing => const AppSpacing();

  AppRadius get radius => const AppRadius();

  AppLocalizations get l10n => AppLocalizations.of(this);

  /// iOS y macOS usan controles Cupertino; el resto, Material.
  bool get isCupertino => switch (theme.platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => true,
    _ => false,
  };
}
