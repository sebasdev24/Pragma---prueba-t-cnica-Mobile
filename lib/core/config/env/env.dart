/// Entornos soportados. Cada uno tiene su entry point (`main_dev.dart`,
/// `main_prod.dart`) y su archivo `.env.<entorno>` en la raíz.
enum EnvType { dev, prod }

/// Contrato común de las clases generadas por Envied.
abstract class Env {
  String get baseUrl;
  String get catApiKey;
  bool get enableDebugTools;
}
