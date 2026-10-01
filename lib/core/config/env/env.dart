import 'package:envied/envied.dart';

part 'env.g.dart';

/// Lee el `.env` al compilar y deja los valores ofuscados en el binario.
/// build_runner no se entera si cambias el `.env`, así que corre primero
/// `dart run build_runner clean` y después
/// `dart run build_runner build --delete-conflicting-outputs`.
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'CAT_API_KEY')
  static final String catApiKey = _Env.catApiKey;
}
