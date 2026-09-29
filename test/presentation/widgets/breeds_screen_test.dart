import 'package:catbreeds/core/di/breed_dependencies.dart';
import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed_page.dart';
import 'package:catbreeds/presentation/modules/breeds/views/breed_detail_screen.dart';
import 'package:catbreeds/presentation/modules/breeds/views/breeds_screen.dart';
import 'package:catbreeds/presentation/modules/breeds/widgets/breed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockBreedRepository repository;

  setUp(() {
    repository = MockBreedRepository();
  });

  // Fotos en null: en pruebas no hay red ni path_provider para la caché.
  final breeds = [
    fakeBreed('abys', name: 'Abyssinian', intelligence: 5),
    fakeBreed('beng', name: 'Bengal', origin: null, countryCode: null),
  ];

  group('BreedsScreen', () {
    testWidgets('muestra las cards con nombre, origen e inteligencia', (
      tester,
    ) async {
      when(
        () => repository.getBreeds(page: 0, limit: any(named: 'limit')),
      ).thenAnswer(
        (_) async => Right(BreedPage(items: breeds, page: 0, total: 2)),
      );

      await tester.pumpApp(
        const BreedsScreen(),
        overrides: [breedRepositoryProvider.overrideWithValue(repository)],
      );
      await tester.pumpAndSettle();

      expect(find.text('Catbreeds'), findsOneWidget);
      expect(find.text('2 RAZAS · THE CAT API'), findsOneWidget);
      expect(find.byType(BreedCard), findsNWidgets(2));
      expect(find.text('Abyssinian'), findsOneWidget);
      expect(find.text('Egypt'), findsOneWidget);
      expect(find.text('5/5'), findsOneWidget);
      // Bengal no trae origen ni inteligencia: estados de "sin dato".
      expect(find.text('Desconocido'), findsOneWidget);
      expect(find.text('Sin dato'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('ESO ES TODO · 2 RAZAS'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('ESO ES TODO · 2 RAZAS'), findsOneWidget);
    });

    testWidgets('error de red en la primera página ofrece reintentar', (
      tester,
    ) async {
      when(
        () => repository.getBreeds(page: 0, limit: any(named: 'limit')),
      ).thenAnswer((_) async => const Left(NetworkFailure('offline')));

      await tester.pumpApp(
        const BreedsScreen(),
        overrides: [breedRepositoryProvider.overrideWithValue(repository)],
      );
      await tester.pumpAndSettle();

      expect(find.text('No pudimos cargar las razas'), findsOneWidget);
      expect(find.textContaining('Revisa tu conexión'), findsOneWidget);

      when(
        () => repository.getBreeds(page: 0, limit: any(named: 'limit')),
      ).thenAnswer(
        (_) async => Right(BreedPage(items: breeds, page: 0, total: 2)),
      );
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(find.byType(BreedCard), findsNWidgets(2));
    });

    testWidgets('búsqueda sin resultados muestra el estado vacío', (
      tester,
    ) async {
      when(
        () => repository.getBreeds(page: 0, limit: any(named: 'limit')),
      ).thenAnswer(
        (_) async => Right(BreedPage(items: breeds, page: 0, total: 2)),
      );
      when(
        () => repository.searchBreeds('xyz'),
      ).thenAnswer((_) async => const Right([]));

      await tester.pumpApp(
        const BreedsScreen(),
        overrides: [breedRepositoryProvider.overrideWithValue(repository)],
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('Sin coincidencias'), findsOneWidget);
      await tester.tap(find.text('Limpiar búsqueda'));
      await tester.pumpAndSettle();
      expect(find.byType(BreedCard), findsNWidgets(2));
    });
  });

  group('BreedDetailScreen', () {
    testWidgets('pide la raza por id y muestra la ficha completa', (
      tester,
    ) async {
      when(
        () => repository.getBreedById('abys'),
      ).thenAnswer((_) async => Right(fakeBreed('abys', name: 'Abyssinian')));

      await tester.pumpApp(
        const BreedDetailScreen(breedId: 'abys'),
        overrides: [breedRepositoryProvider.overrideWithValue(repository)],
      );
      await tester.pumpAndSettle();

      expect(find.text('Abyssinian'), findsNWidgets(2)); // AppBar + título
      expect(find.text('PAÍS DE ORIGEN'), findsOneWidget);
      expect(find.text('INTELIGENCIA'), findsOneWidget);
      expect(find.text('ADAPTABILIDAD'), findsOneWidget);
      expect(find.text('ESPERANZA DE VIDA'), findsOneWidget);
      expect(find.text('12-15 años'), findsOneWidget);
      expect(find.text('Sin dato'), findsNWidgets(2));
    });

    testWidgets('la foto queda fija: solo la ficha hace scroll', (
      tester,
    ) async {
      when(
        () => repository.getBreedById('abys'),
      ).thenAnswer((_) async => Right(fakeBreed('abys', name: 'Abyssinian')));

      await tester.pumpApp(
        const BreedDetailScreen(breedId: 'abys'),
        overrides: [breedRepositoryProvider.overrideWithValue(repository)],
      );
      await tester.pumpAndSettle();

      final photo = find.byType(Hero);
      final before = tester.getTopLeft(photo);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(photo), before);
    });
  });
}
