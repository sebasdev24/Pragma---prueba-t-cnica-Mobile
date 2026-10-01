import 'package:catbreeds/core/di/breed_dependencies.dart';
import 'package:catbreeds/core/router/app_routes.dart';
import 'package:catbreeds/core/theme/app_theme.dart';
import 'package:catbreeds/domain/entities/breed_page.dart';
import 'package:catbreeds/presentation/modules/splash/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  testWidgets(
    'precarga la primera página y pasa a la lista sin errores de Riverpod',
    (tester) async {
      final repository = MockBreedRepository();
      when(
        () => repository.getBreeds(page: 0, limit: any(named: 'limit')),
      ).thenAnswer(
        (_) async =>
            Right(BreedPage(items: [fakeBreed('abys')], page: 0, total: 1)),
      );

      final router = GoRouter(
        initialLocation: AppRoutes.splash,
        routes: [
          GoRoute(
            path: AppRoutes.splash,
            builder: (_, _) => const SplashScreen(),
          ),
          GoRoute(
            path: AppRoutes.breeds,
            builder: (_, _) => const Text('LISTA'),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [breedRepositoryProvider.overrideWithValue(repository)],
          child: MaterialApp.router(
            theme: AppTheme.light,
            routerConfig: router,
          ),
        ),
      );

      expect(find.text('A field guide to cat breeds'), findsOneWidget);
      expect(find.text('Sebastian Agudelo - Pragma PT'), findsOneWidget);

      await tester.pump(SplashScreen.minDuration);
      await tester.pumpAndSettle();

      expect(find.text('LISTA'), findsOneWidget);
      expect(tester.takeException(), isNull);
      verify(() => repository.getBreeds(page: 0, limit: 20)).called(1);
    },
  );
}
