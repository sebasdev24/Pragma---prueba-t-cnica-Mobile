/// Todos los textos que ve el usuario. La app va solo en inglés, igual que
/// los datos que llegan de The Cat API.
class AppStrings {
  const AppStrings._();

  static const appTitle = 'Catbreeds';

  // Splash
  static const splashTagline = 'A field guide to cat breeds';
  static const splashCredit = 'Sebastian Agudelo - Pragma PT';

  // Lista de razas
  static String breedsEyebrow(int count) => '$count BREEDS · THE CAT API';
  static const breedsEyebrowLoading = 'LOADING BREEDS…';
  static const breedsSubtitle = 'Find your perfect breed.';
  static const allBreeds = 'ALL BREEDS';
  static const sortAZ = 'A → Z';
  static const more = 'More';
  static String moreAbout(String name) => 'More about $name';
  static String endOfList(int count) => "THAT'S ALL · $count BREEDS";
  static const loadMoreError = "Couldn't load more breeds.";

  // Búsqueda
  static const searchHint = 'Search breeds';
  static const searchCancel = 'Cancel';
  static const searchClear = 'Clear search';
  static const searching = 'SEARCHING…';
  static String searchResults(int count, String query) =>
      '$count ${count == 1 ? 'RESULT' : 'RESULTS'} FOR “$query”';

  // Datos de la raza
  static const originLabel = 'ORIGIN';
  static const weightLabel = 'WEIGHT';
  static const heightLabel = 'HEIGHT';
  static const lifeSpanLabel = 'LIFE SPAN';
  static String lifeSpanValue(String range) => '${_range(range)} years';
  static String kilograms(String range) => '${_range(range)} kg';
  static String pounds(String range) => '${_range(range)} lb';
  static String centimeters(String range) => '${_range(range)} cm';
  static String inches(String range) => '${_range(range)} in';
  static String countryCodeValue(String code) => 'Code · $code';
  static const noData = 'No data';
  static const unknownOrigin = 'Unknown';
  static const noPhoto = 'No reference photo';
  static String photoOf(String name) => 'Photo of a $name cat';

  // Detalle
  static const breedSheet = 'BREED PROFILE';
  static const temperament = 'TEMPERAMENT';
  static const history = 'HISTORY';
  static String source(String id) => 'SOURCE · API.THECATAPI.COM/V1/BREEDS/$id';

  // Estados vacíos y de error
  static const emptyTitle = 'No matches';
  static String emptyBody(String query) =>
      "We couldn't find breeds for “$query”. "
      'Try the English name, e.g. “Siamese”.';
  static const clearSearch = 'Clear search';
  static const errorTitle = "We couldn't load the breeds";
  static const detailErrorTitle = "We couldn't open this breed";
  static const retry = 'Try again';

  /// La API escribe los rangos a su manera ("3 - 5", "25-30"). Aquí quedan
  /// todos iguales, con raya y sin espacios: "3–5".
  static String _range(String range) =>
      range.trim().replaceAll(RegExp(r'\s*-\s*'), '–');
}
