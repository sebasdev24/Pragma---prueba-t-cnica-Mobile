import 'package:catbreeds/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  /// Monta [child] con el tema de la app y los overrides de Riverpod que
  /// le pases.
  Future<void> pumpApp(Widget child, {List<Override> overrides = const []}) {
    // Pantalla de iPhone 15 (393×852 pt); la de 800×600 por defecto no se
    // parece a ningún teléfono.
    view.physicalSize = const Size(1179, 2556);
    view.devicePixelRatio = 3;
    addTearDown(view.reset);
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(theme: AppTheme.light, home: child),
      ),
    );
  }
}
