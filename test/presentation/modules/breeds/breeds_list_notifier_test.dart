import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed_page.dart';
import 'package:catbreeds/domain/usecases/breed/get_breeds_usecase.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breeds_list_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockBreedRepository repository;
  late BreedsListNotifier notifier;

  BreedPage page(int n, {int size = 2, int total = 5}) => BreedPage(
    items: List.generate(size, (i) => fakeBreed('b${n * size + i}')),
    page: n,
    total: total,
  );

  void stubPage(int n, Either<Failure, BreedPage> result) {
    when(
      () => repository.getBreeds(page: n, limit: 2),
    ).thenAnswer((_) async => result);
  }

  setUp(() {
    repository = MockBreedRepository();
    notifier = BreedsListNotifier(GetBreedsUseCase(repository), pageSize: 2);
  });

  tearDown(() => notifier.dispose());

  test('la primera página deja el estado en success con el total', () async {
    stubPage(0, Right(page(0)));

    await notifier.loadFirstPage();

    expect(notifier.state.status, BreedsListStatus.success);
    expect(notifier.state.items, hasLength(2));
    expect(notifier.state.total, 5);
    expect(notifier.state.hasMore, isTrue);
  });

  test('loadFirstPage es idempotente (splash y lista la llaman)', () async {
    stubPage(0, Right(page(0)));

    await Future.wait([notifier.loadFirstPage(), notifier.loadFirstPage()]);
    await notifier.loadFirstPage();

    verify(() => repository.getBreeds(page: 0, limit: 2)).called(1);
  });

  test('pagina hasta agotar el total y no pide de más', () async {
    stubPage(0, Right(page(0)));
    stubPage(1, Right(page(1)));
    stubPage(2, Right(BreedPage(items: [fakeBreed('b4')], page: 2, total: 5)));

    await notifier.loadFirstPage();
    await notifier.loadMore();
    await notifier.loadMore();
    await notifier.loadMore(); // ya no hay más

    expect(notifier.state.items.map((b) => b.id), [
      'b0',
      'b1',
      'b2',
      'b3',
      'b4',
    ]);
    expect(notifier.state.hasMore, isFalse);
    verifyNever(() => repository.getBreeds(page: 3, limit: 2));
  });

  test('no duplica razas si la API repite una entre páginas', () async {
    stubPage(0, Right(page(0)));
    stubPage(
      1,
      Right(
        BreedPage(items: [fakeBreed('b1'), fakeBreed('b2')], page: 1, total: 5),
      ),
    );

    await notifier.loadFirstPage();
    await notifier.loadMore();

    expect(notifier.state.items.map((b) => b.id), ['b0', 'b1', 'b2']);
  });

  test('un fallo al paginar no borra lo cargado', () async {
    stubPage(0, Right(page(0)));
    stubPage(1, const Left(NetworkFailure('offline')));

    await notifier.loadFirstPage();
    await notifier.loadMore();

    expect(notifier.state.status, BreedsListStatus.success);
    expect(notifier.state.items, hasLength(2));
    expect(notifier.state.loadMoreFailure, isA<NetworkFailure>());
  });

  test('un fallo en la primera página es estado failure', () async {
    stubPage(0, const Left(ServerFailure('down', statusCode: 503)));

    await notifier.loadFirstPage();

    expect(notifier.state.status, BreedsListStatus.failure);
    expect(notifier.state.failure, isA<ServerFailure>());
  });

  test('refresh que falla conserva la lista existente', () async {
    stubPage(0, Right(page(0)));
    await notifier.loadFirstPage();

    stubPage(0, const Left(NetworkFailure('offline')));
    await notifier.refresh();

    expect(notifier.state.status, BreedsListStatus.success);
    expect(notifier.state.items, hasLength(2));
  });
}
