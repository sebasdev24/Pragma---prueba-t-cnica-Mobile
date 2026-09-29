// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Catbreeds';

  @override
  String get splashTagline => 'Guía de razas felinas';

  @override
  String get splashCredit => 'DATOS · THE CAT API';

  @override
  String breedsEyebrow(int count) {
    return '$count RAZAS · THE CAT API';
  }

  @override
  String get breedsEyebrowLoading => 'CARGANDO RAZAS…';

  @override
  String get breedsSubtitle => 'Encuentra tu raza ideal.';

  @override
  String get searchHint => 'Buscar raza (en inglés)';

  @override
  String get searchCancel => 'Cancelar';

  @override
  String get searchClear => 'Borrar búsqueda';

  @override
  String get allBreeds => 'TODAS LAS RAZAS';

  @override
  String get sortAZ => 'A → Z';

  @override
  String searchResults(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count RESULTADOS PARA “$query”',
      one: '1 RESULTADO PARA “$query”',
    );
    return '$_temp0';
  }

  @override
  String get searching => 'BUSCANDO…';

  @override
  String get more => 'Más';

  @override
  String moreAbout(String name) {
    return 'Ver más sobre $name';
  }

  @override
  String get originLabel => 'PAÍS DE ORIGEN';

  @override
  String get intelligenceLabel => 'INTELIGENCIA';

  @override
  String get adaptabilityLabel => 'ADAPTABILIDAD';

  @override
  String get lifeSpanLabel => 'ESPERANZA DE VIDA';

  @override
  String lifeSpanValue(String range) {
    return '$range años';
  }

  @override
  String weightValue(String range) {
    return 'Peso · $range kg';
  }

  @override
  String countryCodeValue(String code) {
    return 'Código · $code';
  }

  @override
  String ratingValue(int value) {
    return '$value/5';
  }

  @override
  String ratingSemantics(String label, int value) {
    return '$label: $value de 5';
  }

  @override
  String get noData => 'Sin dato';

  @override
  String get unknownOrigin => 'Desconocido';

  @override
  String get breedSheet => 'FICHA DE LA RAZA';

  @override
  String get temperament => 'TEMPERAMENTO';

  @override
  String get history => 'HISTORIA';

  @override
  String source(String id) {
    return 'FUENTE · API.THECATAPI.COM/V1/BREEDS/$id';
  }

  @override
  String get noPhoto => 'Sin foto de referencia';

  @override
  String get emptyTitle => 'Sin coincidencias';

  @override
  String emptyBody(String query) {
    return 'No encontramos razas para “$query”. Busca por el nombre en inglés, por ejemplo “Siamese”.';
  }

  @override
  String get clearSearch => 'Limpiar búsqueda';

  @override
  String get errorTitle => 'No pudimos cargar las razas';

  @override
  String get detailErrorTitle => 'No pudimos abrir esta raza';

  @override
  String get retry => 'Reintentar';

  @override
  String get loadMoreError => 'No se pudieron cargar más razas.';

  @override
  String endOfList(int count) {
    return 'ESO ES TODO · $count RAZAS';
  }

  @override
  String get backLabel => 'Razas';

  @override
  String photoOf(String name) {
    return 'Foto de un gato $name';
  }
}
