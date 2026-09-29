import 'dart:async';
import 'dart:ui';

import 'package:catbreeds/app.dart';
import 'package:catbreeds/core/config/app_config.dart';
import 'package:catbreeds/core/config/env/env.dart';
import 'package:catbreeds/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Arranque común a todos los entry points:
/// binding → configuración del entorno → captura de errores → runApp.
Future<void> bootstrap(EnvType envType) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(envType);

  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack, 'FlutterError');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'Uncaught');
    return true;
  };

  runApp(const ProviderScope(child: CatbreedsApp()));
}
