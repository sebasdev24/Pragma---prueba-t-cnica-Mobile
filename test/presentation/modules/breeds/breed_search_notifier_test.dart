import 'dart:async';

import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/domain/usecases/breed/search_breeds_usecase.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breed_search_provider.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  const debounce = Duration(milliseconds: 300);
  late MockBreedRepository repository;
  late BreedSearchNotifier notifier;

  setUp(() {
    repository = MockBreedRepository();
    notifier = BreedSearchNotifier(
      SearchBreedsUseCase(repository),
      debounce: debounce,
    );
  });

  tearDown(() => notifier.dispose());

  test('espera el debounce y hace una sola request por ráfaga', () {
    fakeAsync((async) {
      when(
        () => repository.searchBreeds(any()),
      ).thenAnswer((_) async => Right([fakeBreed('beng', name: 'Bengal')]));

      notifier.onQueryChanged('b');
      notifier.onQueryChanged('be');
      notifier.onQueryChanged('ben');
      expect(notifier.state.status, BreedSearchStatus.loading);

      async.elapse(debounce);
      async.flushMicrotasks();

      verify(() => repository.searchBreeds('ben')).called(1);
      verifyNever(() => repository.searchBreeds('b'));
      expect(notifier.state.status, BreedSearchStatus.success);
      expect(notifier.state.results.single.name, 'Bengal');
    });
  });

  test('una respuesta vieja que llega tarde no pisa a la nueva', () {
    fakeAsync((async) {
      final slow = Completer<Either<Failure, List<Breed>>>();
      when(() => repository.searchBreeds('sia')).thenAnswer((_) => slow.future);
      when(
        () => repository.searchBreeds('siam'),
      ).thenAnswer((_) async => Right([fakeBreed('siam', name: 'Siamese')]));

      notifier.onQueryChanged('sia');
      async.elapse(debounce);
      notifier.onQueryChanged('siam');
      async.elapse(debounce);
      async.flushMicrotasks();

      // La respuesta de "sia" llega tarde, después de la de "siam".
      slow.complete(Right([fakeBreed('pers', name: 'Persian')]));
      async.flushMicrotasks();

      expect(notifier.state.query, 'siam');
      expect(notifier.state.results.single.name, 'Siamese');
    });
  });

  test('borrar el texto vuelve a idle y descarta lo que esté en vuelo', () {
    fakeAsync((async) {
      final slow = Completer<Either<Failure, List<Breed>>>();
      when(() => repository.searchBreeds(any())).thenAnswer((_) => slow.future);

      notifier.onQueryChanged('ben');
      async.elapse(debounce);
      notifier.onQueryChanged('');
      slow.complete(Right([fakeBreed('beng')]));
      async.flushMicrotasks();

      expect(notifier.state.isActive, isFalse);
      expect(notifier.state.status, BreedSearchStatus.idle);
    });
  });

  test('un error queda en estado failure y retry lo recupera', () async {
    when(
      () => repository.searchBreeds('ben'),
    ).thenAnswer((_) async => const Left(NetworkFailure('offline')));

    notifier.onQueryChanged('ben');
    await Future<void>.delayed(debounce + const Duration(milliseconds: 50));
    expect(notifier.state.status, BreedSearchStatus.failure);

    when(
      () => repository.searchBreeds('ben'),
    ).thenAnswer((_) async => Right([fakeBreed('beng')]));
    await notifier.retry();

    expect(notifier.state.status, BreedSearchStatus.success);
  });
}
