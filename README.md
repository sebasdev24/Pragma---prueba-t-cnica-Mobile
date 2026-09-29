# Catbreeds

Catálogo de razas de gato sobre [The Cat API](https://developers.thecatapi.com/). Prueba técnica de desarrollo móvil (Flutter, iOS y Android).

| Splash | Lista | Búsqueda | Detalle |
|---|---|---|---|
| Continúa el splash nativo y precarga la primera página | Cards con nombre, "Más", foto, país de origen e inteligencia | Por nombre en inglés, con debounce | Foto fija; solo la ficha hace scroll |

Diseño en Figma: [Catbreeds — Prueba técnica Pragma](https://www.figma.com/design/qwf9mfXFvY4A6ngNtPgNe3).

## Cómo correrla

Requisitos: Flutter 3.38 (Dart 3.10) o superior.

```bash
# 1. Variables de entorno: copia la plantilla y pega la API key del enunciado
cp .env.example .env.dev
cp .env.example .env.prod      # con ENABLE_DEBUG_TOOLS=false

# 2. Dependencias y código generado (Envied + traducciones)
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# 3. Ejecutar
flutter run -t lib/main_dev.dart
```

La API responde `403` sin la key, así que el paso 1 es obligatorio. La key se compila ofuscada (Envied) y los `.env.*` no se versionan. `build_runner` no detecta cambios en los `.env`: si editas uno, corre antes `dart run build_runner clean`.

```bash
flutter analyze        # lints
flutter test           # 41 pruebas: modelo, red, repositorio, notifiers y widgets
```

## Requisitos del enunciado

| Requisito | Dónde |
|---|---|
| Consumir `/v1/breeds` con `x-api-key` | `ApiKeyInterceptor`, `BreedRemoteDataSource` |
| Splash con título e imagen de gato | `SplashScreen` + splash nativo (`flutter_native_splash`) |
| Landing con cards: nombre, "Más…", imagen, país de origen, inteligencia | `BreedsScreen`, `BreedCard` |
| Buscar la raza en inglés | `/v1/breeds/search` con debounce, `BreedSearchNotifier` |
| Detalle: imagen fija y solo la info con scroll | `BreedDetailScreen`: la foto está fuera del `SingleChildScrollView` |
| Detalle: descripción, país, inteligencia, adaptabilidad, esperanza de vida | Ficha 2×2 (`StatTile`) + temperamento e historia |
| Componentes nativos de cada plataforma | `CupertinoSearchTextField` y "Cancelar" en iOS, `TextField` Material en Android; `RefreshIndicator.adaptive`, `CircularProgressIndicator.adaptive`, `BackButton`, transiciones y física de scroll nativas |

## Un hallazgo sobre la API

Hoy `GET /v1/breeds` **ya no devuelve `intelligence` ni `adaptability`**, aunque el enunciado pide mostrarlos (verificado con la key del enunciado). La app no inventa valores:

- Si la API los manda (escala 1–5), se muestran como escala.
- Si no, la escala aparece vacía con **"Sin dato"** y el lector de pantalla lo anuncia igual.

El parser valida el rango (1–5); si la API vuelve a mandar esos campos, se verán sin tocar la UI. Está cubierto en `test/data/models/breed_model_test.dart`.

## Arquitectura

Clean Architecture en cuatro capas, con la misma estructura de carpetas y convenciones que uso en producción:

```
lib/
├── main_dev.dart · main_prod.dart · bootstrap.dart · app.dart
├── core/          config (Envied), constants, di, errors, extensions,
│                  network (Dio + interceptores), router, theme, utils
├── domain/        entities · repositories (contratos) · usecases
├── data/          datasources · models (DTO) · repositories (impl)
├── presentation/
│   ├── global/widgets/        sistema de diseño (componentes reutilizables)
│   └── modules/
│       ├── splash/views/
│       └── breeds/{providers,views,widgets}/
└── l10n/          ARB en español (por defecto) e inglés
```

- **Flujo de datos:** DataSource → Repository → UseCase → Provider (Riverpod) → UI. La DI vive en `core/di/breed_dependencies.dart` y en las pruebas se sobreescribe `breedRepositoryProvider`.
- **Errores:** nada lanza excepciones por encima de `data`. `DioClient` traduce cada error a un `Failure` tipado (`NetworkFailure`, `ServerFailure`, `ParsingFailure`…) y todo viaja como `Either<Failure, T>` (fpdart). Cada `Failure` sabe su `userMessage`.
- **Red:** `RetryInterceptor` (solo GET, backoff exponencial, no reintenta 4xx) → `ApiKeyInterceptor` → `TalkerDioLogger` (solo en dev).

Más detalle en [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Decisiones

- **Paginación con scroll infinito** (`limit=20`, total leído del header `pagination-count`). La primera página se pide durante la splash, así la lista abre con datos. Un fallo al paginar no borra lo cargado: solo el pie ofrece reintentar.
- **Búsqueda contra la API** (`/breeds/search?attach_image=1`), no filtrado local. Debounce de 350 ms, y cada búsqueda lleva un número de generación: si "ben" responde después que "beng", se descarta. Hay prueba para ese caso.
- **Imágenes:** las originales pesan 1–6 MB y miden hasta 4000 px. Se decodifican al ancho real en pantalla (`memCacheWidth`), con caché en disco y un fallback de marca para las 41 razas sin foto.
- **Estado de la lista persistente:** el provider no es `autoDispose`, así que al volver del detalle se conservan las páginas y la posición. El detalle reutiliza la raza ya cargada y solo va a la red en un deep link (`/breeds/:id`).
- **Sistema de diseño:** tokens en dos niveles (`AppPalette` → `AppColorsExtension`), tipografía (Fraunces, Geist y Geist Mono empaquetadas) y espaciado, espejo de las variables de Figma. Las vistas no usan colores ni tamaños sueltos.
- **Skeletons:** un solo `AppShimmer` por vista y un único degradado; cada bloque pinta su porción, así brillan en fase. Respeta "reducir movimiento".
- **Accesibilidad:** escalas con etiqueta semántica ("Inteligencia: 4 de 5"), títulos marcados como encabezado, fotos con descripción y botón "Más" con nombre ("Ver más sobre Bengal").

## Stack

Flutter 3.38 · Riverpod 2 · go_router · Dio · fpdart · Envied · cached_network_image · flutter_svg · talker · mocktail.

Fuentes: Fraunces, Geist y Geist Mono (SIL Open Font License).
