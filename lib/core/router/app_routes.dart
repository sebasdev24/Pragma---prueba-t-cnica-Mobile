class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String breeds = '/breeds';

  /// El detalle vive en `/breeds/:id`, así que también se puede abrir con
  /// un deep link.
  static const String breedDetail = 'detail';
  static const String breedIdParam = 'id';
  static String breedDetailPath(String id) => '$breeds/$id';
}
