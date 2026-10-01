import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/domain/repositories/breed_repository.dart';
import 'package:fpdart/fpdart.dart';

class SearchBreedsUseCase {
  final BreedRepository repository;
  SearchBreedsUseCase(this.repository);

  /// Si la búsqueda está vacía no vale la pena ir a la red.
  Future<Either<Failure, List<Breed>>> call(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const Right([]);
    return repository.searchBreeds(q);
  }
}
