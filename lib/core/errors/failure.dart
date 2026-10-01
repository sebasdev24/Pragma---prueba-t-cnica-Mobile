import 'package:equatable/equatable.dart';

/// Cualquier cosa que salga mal termina siendo un `Failure`. De `data`
/// hacia arriba nadie atrapa excepciones: los errores llegan como
/// `Either<Failure, T>` y cada uno sabe qué mensaje mostrar.
sealed class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  /// Lo que ve el usuario. [message] queda para los logs.
  String get userMessage => message;

  @override
  List<Object?> get props => [message, statusCode];
}

/// La API contestó, pero con un error (4xx o 5xx).
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});

  @override
  String get userMessage => switch (statusCode) {
    401 || 403 => "We couldn't authenticate with The Cat API.",
    404 => "We couldn't find this breed.",
    429 => 'Too many requests. Wait a moment and try again.',
    _ => 'The breeds service is unavailable right now.',
  };
}

/// No hubo respuesta: sin internet o se agotó el tiempo.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);

  @override
  String get userMessage => 'Check your internet connection and try again.';
}

/// Llegó una respuesta, pero no con la forma que esperábamos.
final class ParsingFailure extends Failure {
  const ParsingFailure(super.message);

  @override
  String get userMessage => 'We received unexpected data from the service.';
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);

  @override
  String get userMessage => 'Something went wrong. Please try again.';
}
