import 'package:envied/envied.dart';

part 'prod_env.g.dart';

/// Variables de PROD, leídas de `.env.prod` en tiempo de compilación.
/// Tras cambiarlas: `dart run build_runner build --delete-conflicting-outputs`.
@Envied(path: '.env.prod', obfuscate: true)
abstract class ProdEnv {
  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _ProdEnv.baseUrl;

  @EnviedField(varName: 'CAT_API_KEY')
  static final String catApiKey = _ProdEnv.catApiKey;

  @EnviedField(varName: 'ENABLE_DEBUG_TOOLS', defaultValue: false)
  static final bool enableDebugTools = _ProdEnv.enableDebugTools;
}
