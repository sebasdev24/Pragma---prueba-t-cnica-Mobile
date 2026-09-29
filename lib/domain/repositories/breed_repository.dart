import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/domain/entities/breed_page.dart';
import 'package:fpdart/fpdart.dart';

/// Contrato del catálogo de razas. Nunca lanza: todo error vuelve como
/// [Failure].
abstract class BreedRepository {
  /// Listado paginado. `page` empieza en 0.
  Future<Either<Failure, BreedPage>> getBreeds({
    required int page,
    required int limit,
  });

  /// Búsqueda por nombre (en inglés, como la API).
  Future<Either<Failure, List<Breed>>> searchBreeds(String query);

  /// Detalle de una raza. Sirve cuando se llega al detalle sin pasar por
  /// la lista (deep link o restauración de estado).
  Future<Either<Failure, Breed>> getBreedById(String id);
}
