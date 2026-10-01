import 'package:catbreeds/core/constants/app_strings.dart';
import 'package:catbreeds/core/router/app_router.dart';
import 'package:catbreeds/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatbreedsApp extends ConsumerWidget {
  const CatbreedsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
