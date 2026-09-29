import 'package:catbreeds/core/router/app_router.dart';
import 'package:catbreeds/core/theme/app_theme.dart';
import 'package:catbreeds/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatbreedsApp extends ConsumerWidget {
  const CatbreedsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(appRouterProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Español por defecto; inglés si el dispositivo está en inglés.
      localeResolutionCallback: (locale, supported) {
        return supported.firstWhere(
          (l) => l.languageCode == locale?.languageCode,
          orElse: () => const Locale('es'),
        );
      },
    );
  }
}
