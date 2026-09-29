import 'package:equatable/equatable.dart';

/// Error de dominio. Ninguna capa por encima de `data` ve excepciones:
/// todo llega como `Either<Failure, T>`.
sealed class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  /// Texto listo para mostrar al usuario.
  String get userMessage => message;

  @override
  List<Object?> get props => [message, statusCode];
}

/// La API respondió con un error (4xx/5xx).
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});

  @override
  String get userMessage => switch (statusCode) {
    401 || 403 => 'No pudimos autenticarnos con The Cat API.',
    404 => 'No encontramos esta raza.',
    429 => 'Demasiadas solicitudes. Espera un momento e inténtalo de nuevo.',
    _ => 'El servicio de razas no está disponible ahora mismo.',
  };
}

/// Sin conexión o timeout.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);

  @override
  String get userMessage =>
      'Revisa tu conexión a internet e inténtalo de nuevo.';
}

/// La request se canceló a propósito (p. ej. una búsqueda reemplazada por
/// otra más reciente). No es un error que se deba mostrar.
final class CancelledFailure extends Failure {
  const CancelledFailure() : super('Request cancelled');
}

/// La respuesta llegó pero no tiene la forma esperada.
final class ParsingFailure extends Failure {
  const ParsingFailure(super.message);

  @override
  String get userMessage => 'Recibimos datos inesperados del servicio.';
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);

  @override
  String get userMessage => 'Algo salió mal. Inténtalo de nuevo.';
}
