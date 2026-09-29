import 'package:catbreeds/bootstrap.dart';
import 'package:catbreeds/core/config/env/env.dart';

/// Entry point de DEV. Lee `.env.dev`.
///
/// flutter run -t lib/main_dev.dart
Future<void> main() => bootstrap(EnvType.dev);
