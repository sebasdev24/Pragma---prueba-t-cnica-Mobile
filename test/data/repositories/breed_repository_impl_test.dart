import 'package:catbreeds/core/errors/exceptions.dart';
import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/data/models/breed/breed_model.dart';
import 'package:catbreeds/data/repositories/breed_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/breed_fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockBreedRemoteDataSource remote;
  late BreedRepositoryImpl repository;

  setUp(() {
    remote = MockBreedRemoteDataSource();
    repository = BreedRepositoryImpl(remoteDataSource: remote);
  });

  test('getBreeds devuelve Right con entidades y la página pedida', () async {
    when(() => remote.getBreeds(page: 1, limit: 20)).thenAnswer(
      (_) async => (items: [BreedModel.fromJson(abyssinianJson)], total: 107),
    );

    final result = await repository.getBreeds(page: 1, limit: 20);

    final page = result.getOrElse((_) => throw StateError('Left'));
    expect(page.items.single.name, 'Abyssinian');
    expect(page.page, 1);
    expect(page.total, 107);
  });

  test('conserva el Failure tipado que viene del datasource', () async {
    when(
      () => remote.searchBreeds('x'),
    ).thenThrow(const FailureException(NetworkFailure('offline')));

    final result = await repository.searchBreeds('x');

    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
  });

  test('una excepción inesperada es UnknownFailure y nunca escapa', () async {
    when(() => remote.getBreedById('abys')).thenThrow(StateError('boom'));

    final result = await repository.getBreedById('abys');

    expect(result.getLeft().toNullable(), isA<UnknownFailure>());
  });
}
