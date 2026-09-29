import 'package:catbreeds/core/router/app_routes.dart';
import 'package:catbreeds/presentation/modules/breeds/views/breed_detail_screen.dart';
import 'package:catbreeds/presentation/modules/breeds/views/breeds_screen.dart';
import 'package:catbreeds/presentation/modules/splash/views/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Rutas de la app. Las transiciones son las nativas de cada plataforma
/// (deslizar en iOS con gesto de volver, zoom/fade en Android).
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.breeds,
        builder: (_, _) => const BreedsScreen(),
        routes: [
          GoRoute(
            name: AppRoutes.breedDetail,
            path: ':${AppRoutes.breedIdParam}',
            builder: (_, state) => BreedDetailScreen(
              breedId: state.pathParameters[AppRoutes.breedIdParam]!,
            ),
          ),
        ],
      ),
    ],
  );
});
