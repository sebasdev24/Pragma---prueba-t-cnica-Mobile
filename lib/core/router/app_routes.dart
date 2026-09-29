class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String breeds = '/breeds';

  /// Detalle: `/breeds/:id`. También sirve como deep link.
  static const String breedDetail = 'detail';
  static const String breedIdParam = 'id';
  static String breedDetailPath(String id) => '$breeds/$id';
}
