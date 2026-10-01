import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/domain/entities/breed_page.dart';
import 'package:fpdart/fpdart.dart';

/// Lo que la app necesita del catálogo de razas. Ningún método lanza: si
/// algo sale mal, vuelve un [Failure].
abstract class BreedRepository {
  /// El listado, por páginas. La primera es la 0.
  Future<Either<Failure, BreedPage>> getBreeds({
    required int page,
    required int limit,
  });

  /// Busca por nombre. Los nombres están en inglés, como en la API.
  Future<Either<Failure, List<Breed>>> searchBreeds(String query);

  /// Una raza por su id. Solo hace falta cuando se abre el detalle sin
  /// pasar por la lista, por ejemplo con un deep link.
  Future<Either<Failure, Breed>> getBreedById(String id);
}
