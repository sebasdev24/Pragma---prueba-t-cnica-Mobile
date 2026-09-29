import 'package:catbreeds/domain/usecases/breed/search_breeds_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockBreedRepository repository;
  late SearchBreedsUseCase useCase;

  setUp(() {
    repository = MockBreedRepository();
    useCase = SearchBreedsUseCase(repository);
  });

  test('una consulta vacía no llega a la red', () async {
    final result = await useCase('   ');

    expect(result.getOrElse((_) => throw StateError('Left')), isEmpty);
    verifyNever(() => repository.searchBreeds(any()));
  });

  test('recorta espacios antes de buscar', () async {
    when(
      () => repository.searchBreeds('sia'),
    ).thenAnswer((_) async => Right([fakeBreed('siam')]));

    await useCase('  sia ');

    verify(() => repository.searchBreeds('sia')).called(1);
  });
}
