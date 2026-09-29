import 'package:catbreeds/core/theme/app_theme.dart';
import 'package:catbreeds/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  /// Monta [child] con el tema, las traducciones en español y los
  /// overrides de Riverpod indicados.
  Future<void> pumpApp(Widget child, {List<Override> overrides = const []}) {
    // Tamaño de un iPhone 15 (393×852 pt), no el 800×600 por defecto.
    view.physicalSize = const Size(1179, 2556);
    view.devicePixelRatio = 3;
    addTearDown(view.reset);
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      ),
    );
  }
}
