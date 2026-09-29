import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed_page.dart';
import 'package:catbreeds/domain/repositories/breed_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetBreedsUseCase {
  final BreedRepository repository;
  GetBreedsUseCase(this.repository);

  Future<Either<Failure, BreedPage>> call({
    required int page,
    required int limit,
  }) {
    return repository.getBreeds(page: page, limit: limit);
  }
}
