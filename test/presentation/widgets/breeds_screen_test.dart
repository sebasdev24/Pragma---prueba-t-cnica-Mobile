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

  // Sin fotos, porque en las pruebas no hay red ni caché en disco.
  final breeds = [
    fakeBreed('abys', name: 'Abyssinian'),
    fakeBreed(
      'beng',
      name: 'Bengal',
      origin: null,
      countryCode: null,
      weightKg: null,
    ),
  ];

  group('BreedsScreen', () {
    testWidgets('muestra las cards con nombre, origen y peso', (tester) async {
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
      expect(find.text('2 BREEDS · THE CAT API'), findsOneWidget);
      expect(find.byType(BreedCard), findsNWidgets(2));
      expect(find.text('Abyssinian'), findsOneWidget);
      expect(find.text('Egypt'), findsOneWidget);
      expect(find.text('3–5 kg'), findsOneWidget);
      // Bengal viene sin origen ni peso, así que se ve el "No data".
      expect(find.text('Unknown'), findsOneWidget);
      expect(find.text('No data'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text("THAT'S ALL · 2 BREEDS"),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text("THAT'S ALL · 2 BREEDS"), findsOneWidget);
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

      expect(find.text("We couldn't load the breeds"), findsOneWidget);
      expect(
        find.textContaining('Check your internet connection'),
        findsOneWidget,
      );

      when(
        () => repository.getBreeds(page: 0, limit: any(named: 'limit')),
      ).thenAnswer(
        (_) async => Right(BreedPage(items: breeds, page: 0, total: 2)),
      );
      await tester.tap(find.text('Try again'));
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

      expect(find.text('No matches'), findsOneWidget);
      await tester.tap(find.text('Clear search'));
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
      expect(find.text('ORIGIN'), findsOneWidget);
      expect(find.text('WEIGHT'), findsOneWidget);
      expect(find.text('HEIGHT'), findsOneWidget);
      expect(find.text('LIFE SPAN'), findsOneWidget);
      expect(find.text('3–5 kg'), findsOneWidget);
      expect(find.text('7–11 lb'), findsOneWidget);
      expect(find.text('25–30 cm'), findsOneWidget);
      expect(find.text('10–12 in'), findsOneWidget);
      expect(find.text('12–15 years'), findsOneWidget);
      expect(find.text('No data'), findsNothing);
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
