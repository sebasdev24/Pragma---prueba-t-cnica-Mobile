import 'package:catbreeds/core/network/network_provider.dart';
import 'package:catbreeds/data/datasources/breed/breed_remote_datasource.dart';
import 'package:catbreeds/data/repositories/breed_repository_impl.dart';
import 'package:catbreeds/domain/repositories/breed_repository.dart';
import 'package:catbreeds/domain/usecases/breed/get_breed_by_id_usecase.dart';
import 'package:catbreeds/domain/usecases/breed/get_breeds_usecase.dart';
import 'package:catbreeds/domain/usecases/breed/search_breeds_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final breedRemoteDataSourceProvider = Provider<BreedRemoteDataSource>((ref) {
  return BreedRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

final breedRepositoryProvider = Provider<BreedRepository>((ref) {
  return BreedRepositoryImpl(
    remoteDataSource: ref.watch(breedRemoteDataSourceProvider),
  );
});

final getBreedsUseCaseProvider = Provider<GetBreedsUseCase>((ref) {
  return GetBreedsUseCase(ref.watch(breedRepositoryProvider));
});

final searchBreedsUseCaseProvider = Provider<SearchBreedsUseCase>((ref) {
  return SearchBreedsUseCase(ref.watch(breedRepositoryProvider));
});

final getBreedByIdUseCaseProvider = Provider<GetBreedByIdUseCase>((ref) {
  return GetBreedByIdUseCase(ref.watch(breedRepositoryProvider));
});
