import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/domain/repositories/breed_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetBreedByIdUseCase {
  final BreedRepository repository;
  GetBreedByIdUseCase(this.repository);

  Future<Either<Failure, Breed>> call(String id) {
    return repository.getBreedById(id);
  }
}
