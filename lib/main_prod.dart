import 'package:catbreeds/bootstrap.dart';
import 'package:catbreeds/core/config/env/env.dart';

/// Entry point de PROD. Lee `.env.prod`.
///
/// flutter run --release -t lib/main_prod.dart
Future<void> main() => bootstrap(EnvType.prod);
