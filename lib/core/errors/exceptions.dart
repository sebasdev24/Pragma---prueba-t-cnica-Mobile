import 'package:catbreeds/core/errors/failure.dart';

/// El datasource trabaja con `Future` normales, así que cuando algo falla
/// necesita lanzar. Esta excepción lleva el [Failure] adentro para que no
/// se pierda el tipo en el camino; el repositorio la atrapa y lo saca.
class FailureException implements Exception {
  final Failure failure;

  const FailureException(this.failure);

  @override
  String toString() => 'FailureException: ${failure.message}';
}
