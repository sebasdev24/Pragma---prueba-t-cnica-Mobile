import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Catbreeds'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In es, this message translates to:
  /// **'Guía de razas felinas'**
  String get splashTagline;

  /// No description provided for @splashCredit.
  ///
  /// In es, this message translates to:
  /// **'DATOS · THE CAT API'**
  String get splashCredit;

  /// No description provided for @breedsEyebrow.
  ///
  /// In es, this message translates to:
  /// **'{count} RAZAS · THE CAT API'**
  String breedsEyebrow(int count);

  /// No description provided for @breedsEyebrowLoading.
  ///
  /// In es, this message translates to:
  /// **'CARGANDO RAZAS…'**
  String get breedsEyebrowLoading;

  /// No description provided for @breedsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Encuentra tu raza ideal.'**
  String get breedsSubtitle;

  /// No description provided for @searchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar raza (en inglés)'**
  String get searchHint;

  /// No description provided for @searchCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get searchCancel;

  /// No description provided for @searchClear.
  ///
  /// In es, this message translates to:
  /// **'Borrar búsqueda'**
  String get searchClear;

  /// No description provided for @allBreeds.
  ///
  /// In es, this message translates to:
  /// **'TODAS LAS RAZAS'**
  String get allBreeds;

  /// No description provided for @sortAZ.
  ///
  /// In es, this message translates to:
  /// **'A → Z'**
  String get sortAZ;

  /// No description provided for @searchResults.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 RESULTADO PARA “{query}”} other{{count} RESULTADOS PARA “{query}”}}'**
  String searchResults(int count, String query);

  /// No description provided for @searching.
  ///
  /// In es, this message translates to:
  /// **'BUSCANDO…'**
  String get searching;

  /// No description provided for @more.
  ///
  /// In es, this message translates to:
  /// **'Más'**
  String get more;

  /// No description provided for @moreAbout.
  ///
  /// In es, this message translates to:
  /// **'Ver más sobre {name}'**
  String moreAbout(String name);

  /// No description provided for @originLabel.
  ///
  /// In es, this message translates to:
  /// **'PAÍS DE ORIGEN'**
  String get originLabel;

  /// No description provided for @intelligenceLabel.
  ///
  /// In es, this message translates to:
  /// **'INTELIGENCIA'**
  String get intelligenceLabel;

  /// No description provided for @adaptabilityLabel.
  ///
  /// In es, this message translates to:
  /// **'ADAPTABILIDAD'**
  String get adaptabilityLabel;

  /// No description provided for @lifeSpanLabel.
  ///
  /// In es, this message translates to:
  /// **'ESPERANZA DE VIDA'**
  String get lifeSpanLabel;

  /// No description provided for @lifeSpanValue.
  ///
  /// In es, this message translates to:
  /// **'{range} años'**
  String lifeSpanValue(String range);

  /// No description provided for @weightValue.
  ///
  /// In es, this message translates to:
  /// **'Peso · {range} kg'**
  String weightValue(String range);

  /// No description provided for @countryCodeValue.
  ///
  /// In es, this message translates to:
  /// **'Código · {code}'**
  String countryCodeValue(String code);

  /// No description provided for @ratingValue.
  ///
  /// In es, this message translates to:
  /// **'{value}/5'**
  String ratingValue(int value);

  /// No description provided for @ratingSemantics.
  ///
  /// In es, this message translates to:
  /// **'{label}: {value} de 5'**
  String ratingSemantics(String label, int value);

  /// No description provided for @noData.
  ///
  /// In es, this message translates to:
  /// **'Sin dato'**
  String get noData;

  /// No description provided for @unknownOrigin.
  ///
  /// In es, this message translates to:
  /// **'Desconocido'**
  String get unknownOrigin;

  /// No description provided for @breedSheet.
  ///
  /// In es, this message translates to:
  /// **'FICHA DE LA RAZA'**
  String get breedSheet;

  /// No description provided for @temperament.
  ///
  /// In es, this message translates to:
  /// **'TEMPERAMENTO'**
  String get temperament;

  /// No description provided for @history.
  ///
  /// In es, this message translates to:
  /// **'HISTORIA'**
  String get history;

  /// No description provided for @source.
  ///
  /// In es, this message translates to:
  /// **'FUENTE · API.THECATAPI.COM/V1/BREEDS/{id}'**
  String source(String id);

  /// No description provided for @noPhoto.
  ///
  /// In es, this message translates to:
  /// **'Sin foto de referencia'**
  String get noPhoto;

  /// No description provided for @emptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin coincidencias'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In es, this message translates to:
  /// **'No encontramos razas para “{query}”. Busca por el nombre en inglés, por ejemplo “Siamese”.'**
  String emptyBody(String query);

  /// No description provided for @clearSearch.
  ///
  /// In es, this message translates to:
  /// **'Limpiar búsqueda'**
  String get clearSearch;

  /// No description provided for @errorTitle.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar las razas'**
  String get errorTitle;

  /// No description provided for @detailErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'No pudimos abrir esta raza'**
  String get detailErrorTitle;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @loadMoreError.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar más razas.'**
  String get loadMoreError;

  /// No description provided for @endOfList.
  ///
  /// In es, this message translates to:
  /// **'ESO ES TODO · {count} RAZAS'**
  String endOfList(int count);

  /// No description provided for @backLabel.
  ///
  /// In es, this message translates to:
  /// **'Razas'**
  String get backLabel;

  /// No description provided for @photoOf.
  ///
  /// In es, this message translates to:
  /// **'Foto de un gato {name}'**
  String photoOf(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
