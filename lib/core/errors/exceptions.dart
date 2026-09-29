import 'package:catbreeds/core/errors/failure.dart';

/// Envuelve un [Failure] tipado para atravesar la frontera
/// datasource → repository sin degradarlo a un string. El repository lo
/// desenvuelve con `on FailureException`.
class FailureException implements Exception {
  final Failure failure;

  const FailureException(this.failure);

  @override
  String toString() => 'FailureException: ${failure.message}';
}
