# Arquitectura

## Capas

| Capa | Depende de | Contiene | Regla |
|---|---|---|---|
| `domain/` | nada (Dart puro + fpdart/equatable) | `Breed`, `BreedPage`, `BreedRepository` (contrato), casos de uso | No importa Flutter, Dio ni `data/`. |
| `data/` | `domain`, `core` | `BreedModel` (DTO), `BreedRemoteDataSource`, `BreedRepositoryImpl` | Único lugar con `try/catch`. Devuelve `Either<Failure, T>`. |
| `presentation/` | `domain`, `core` | Providers, vistas y widgets | No importa `data/` salvo a través de la DI. |
| `core/` | — | Config, red, errores, tema, router, DI | Transversal. |

## Recorrido de una request

```
BreedsScreen ──ref.read──▶ BreedsListNotifier.loadMore()
                               │
                               ▼
                         GetBreedsUseCase(page, limit)
                               │
                               ▼
                   BreedRepositoryImpl.getBreeds ── _guard ──┐
                               │                              │ FailureException → Left(failure)
                               ▼                              │ otra excepción   → Left(UnknownFailure)
                 BreedRemoteDataSource.getBreeds               │
                               │                              │
                               ▼                              │
                  DioClient.get ── Either<Failure, Response> ─┘
                               │
            ApiKeyInterceptor → LogInterceptor (solo debug) → The Cat API
```

`DioClient` nunca lanza: devuelve `Left(Failure)`. El datasource, que necesita devolver modelos y no `Either`, envuelve ese `Failure` en `FailureException`. El repositorio lo desenvuelve **sin perder el tipo**: `NetworkFailure` sigue siendo `NetworkFailure` y la UI muestra "Check your internet connection…" en lugar de un texto genérico.

## Estado (Riverpod)

| Provider | Tipo | Por qué |
|---|---|---|
| `breedsListProvider` | `StateNotifierProvider` (persistente) | Lista paginada; conserva páginas y posición al volver del detalle. |
| `breedSearchProvider` | `StateNotifierProvider` (persistente) | Debounce y descarte de respuestas viejas por generación. |
| `breedDetailProvider` | `FutureProvider.autoDispose.family` | Usa la raza en memoria si existe; si no (deep link), la pide por id. |
| `breedRepositoryProvider` | `Provider` | Punto de sustitución en pruebas. |

Ningún provider se modifica durante `initState` ni `build`: las cargas iniciales se disparan en `addPostFrameCallback` (hay una prueba de regresión en `test/presentation/widgets/splash_screen_test.dart`).

## Sistema de diseño

Los tokens espejan las variables del archivo de Figma:

- **Color:** `AppPalette` (primitivos) → `AppColorsExtension` (semánticos: `background`, `surface`, `sunken`, `foreground*`, `border*`, `accent*`, `danger*`). Solo tema claro. Uso: `context.colors.accent`.
- **Tipografía:** `context.typography.display.{xl,lg,md,italic}` (Fraunces), `system.{headline,body,callout,subhead,caption}` (Geist) y `mono.label` (Geist Mono).
- **Espaciado y radios:** `context.spacing.{sx…safe}` y `context.radius.{xs…full}`.
- **Componentes globales** (`presentation/global/widgets/`): `AppSearchField` (adaptativo), `AppNetworkImage`, `AppShimmer` + `AppShimmerBox`, `StatTile`, `AppStatusView`, `AppChip`, `AppLabel`, botones y `CatMark`. Las vistas los usan en vez de recrearlos.

## Configuración

Un solo entorno. `Env` expone `baseUrl` y `catApiKey`, leídos en compilación de `.env` con Envied (ofuscados); los logs de red solo se activan en debug. `build_runner` no detecta cambios en el `.env`: tras editarlo, `dart run build_runner clean` y luego `build --delete-conflicting-outputs`.

## Pruebas

```
test/
├── core/network/        mapeo DioException → Failure
├── data/                modelo (campos ausentes, unidades métricas e imperiales),
│                        datasource (paginación, registros malformados), repositorio
├── domain/usecases/     búsqueda vacía no llega a la red
├── presentation/modules/ notifiers: paginación, deduplicado, errores, debounce,
│                        respuestas fuera de orden
└── presentation/widgets/ lista, error y reintento, búsqueda vacía, detalle,
                         foto fija durante el scroll, splash
```
