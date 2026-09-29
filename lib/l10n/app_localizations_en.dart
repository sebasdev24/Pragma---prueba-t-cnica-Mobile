// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Catbreeds';

  @override
  String get splashTagline => 'A field guide to cat breeds';

  @override
  String get splashCredit => 'DATA · THE CAT API';

  @override
  String breedsEyebrow(int count) {
    return '$count BREEDS · THE CAT API';
  }

  @override
  String get breedsEyebrowLoading => 'LOADING BREEDS…';

  @override
  String get breedsSubtitle => 'Find your perfect breed.';

  @override
  String get searchHint => 'Search breeds';

  @override
  String get searchCancel => 'Cancel';

  @override
  String get searchClear => 'Clear search';

  @override
  String get allBreeds => 'ALL BREEDS';

  @override
  String get sortAZ => 'A → Z';

  @override
  String searchResults(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count RESULTS FOR “$query”',
      one: '1 RESULT FOR “$query”',
    );
    return '$_temp0';
  }

  @override
  String get searching => 'SEARCHING…';

  @override
  String get more => 'More';

  @override
  String moreAbout(String name) {
    return 'More about $name';
  }

  @override
  String get originLabel => 'ORIGIN';

  @override
  String get intelligenceLabel => 'INTELLIGENCE';

  @override
  String get adaptabilityLabel => 'ADAPTABILITY';

  @override
  String get lifeSpanLabel => 'LIFE SPAN';

  @override
  String lifeSpanValue(String range) {
    return '$range years';
  }

  @override
  String weightValue(String range) {
    return 'Weight · $range kg';
  }

  @override
  String countryCodeValue(String code) {
    return 'Code · $code';
  }

  @override
  String ratingValue(int value) {
    return '$value/5';
  }

  @override
  String ratingSemantics(String label, int value) {
    return '$label: $value out of 5';
  }

  @override
  String get noData => 'No data';

  @override
  String get unknownOrigin => 'Unknown';

  @override
  String get breedSheet => 'BREED PROFILE';

  @override
  String get temperament => 'TEMPERAMENT';

  @override
  String get history => 'HISTORY';

  @override
  String source(String id) {
    return 'SOURCE · API.THECATAPI.COM/V1/BREEDS/$id';
  }

  @override
  String get noPhoto => 'No reference photo';

  @override
  String get emptyTitle => 'No matches';

  @override
  String emptyBody(String query) {
    return 'We couldn\'t find breeds for “$query”. Try the English name, e.g. “Siamese”.';
  }

  @override
  String get clearSearch => 'Clear search';

  @override
  String get errorTitle => 'We couldn\'t load the breeds';

  @override
  String get detailErrorTitle => 'We couldn\'t open this breed';

  @override
  String get retry => 'Try again';

  @override
  String get loadMoreError => 'Couldn\'t load more breeds.';

  @override
  String endOfList(int count) {
    return 'THAT\'S ALL · $count BREEDS';
  }

  @override
  String get backLabel => 'Breeds';

  @override
  String photoOf(String name) {
    return 'Photo of a $name cat';
  }
}
