import 'package:envied/envied.dart';

part 'dev_env.g.dart';

/// Variables de DEV, leídas de `.env.dev` en tiempo de compilación.
/// Tras cambiarlas: `dart run build_runner build --delete-conflicting-outputs`.
@Envied(path: '.env.dev', obfuscate: true)
abstract class DevEnv {
  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _DevEnv.baseUrl;

  @EnviedField(varName: 'CAT_API_KEY')
  static final String catApiKey = _DevEnv.catApiKey;

  @EnviedField(varName: 'ENABLE_DEBUG_TOOLS', defaultValue: true)
  static final bool enableDebugTools = _DevEnv.enableDebugTools;
}
