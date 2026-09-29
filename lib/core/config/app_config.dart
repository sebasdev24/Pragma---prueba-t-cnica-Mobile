import 'package:catbreeds/core/config/env/dev_env.dart';
import 'package:catbreeds/core/config/env/env.dart';
import 'package:catbreeds/core/config/env/prod_env.dart';

/// Punto único de acceso a la configuración del entorno activo.
/// Se inicializa una sola vez en `bootstrap()` antes de `runApp()`.
class AppConfig {
  const AppConfig._();

  static late final Env _env;
  static late final EnvType _envType;

  static void init(EnvType type) {
    _envType = type;
    _env = switch (type) {
      EnvType.dev => _DevEnvImpl(),
      EnvType.prod => _ProdEnvImpl(),
    };
  }

  static String get baseUrl => _env.baseUrl;
  static String get catApiKey => _env.catApiKey;
  static bool get enableDebugTools => _env.enableDebugTools;
  static EnvType get environment => _envType;
}

class _DevEnvImpl implements Env {
  @override
  String get baseUrl => DevEnv.baseUrl;
  @override
  String get catApiKey => DevEnv.catApiKey;
  @override
  bool get enableDebugTools => DevEnv.enableDebugTools;
}

class _ProdEnvImpl implements Env {
  @override
  String get baseUrl => ProdEnv.baseUrl;
  @override
  String get catApiKey => ProdEnv.catApiKey;
  @override
  bool get enableDebugTools => ProdEnv.enableDebugTools;
}
