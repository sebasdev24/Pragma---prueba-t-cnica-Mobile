import 'package:catbreeds/core/errors/exceptions.dart';
import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/data/datasources/breed/breed_remote_datasource.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/domain/entities/breed_page.dart';
import 'package:catbreeds/domain/repositories/breed_repository.dart';
import 'package:fpdart/fpdart.dart';

class BreedRepositoryImpl implements BreedRepository {
  final BreedRemoteDataSource _remote;

  BreedRepositoryImpl({required BreedRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  @override
  Future<Either<Failure, BreedPage>> getBreeds({
    required int page,
    required int limit,
  }) {
    return _guard(() async {
      final result = await _remote.getBreeds(page: page, limit: limit);
      return BreedPage(
        items: result.items.map((m) => m.toEntity()).toList(growable: false),
        page: page,
        total: result.total,
      );
    });
  }

  @override
  Future<Either<Failure, List<Breed>>> searchBreeds(String query) {
    return _guard(() async {
      final models = await _remote.searchBreeds(query);
      return models.map((m) => m.toEntity()).toList(growable: false);
    });
  }

  @override
  Future<Either<Failure, Breed>> getBreedById(String id) {
    return _guard(() async {
      final model = await _remote.getBreedById(id);
      return model.toEntity();
    });
  }

  /// El único try/catch de la capa de datos. Lo que salga de aquí ya es
  /// un `Either`; si llega algo inesperado, queda como `UnknownFailure`.
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Right(await body());
    } on FailureException catch (e) {
      return Left(e.failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
