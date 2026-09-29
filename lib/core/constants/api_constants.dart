/// Rutas y parámetros de The Cat API (https://developers.thecatapi.com/).
class ApiConstants {
  const ApiConstants._();

  static const String breeds = '/breeds';
  static const String breedsSearch = '/breeds/search';
  static String breedById(String id) => '/breeds/$id';

  /// Header de autenticación. La API responde 403 sin él.
  static const String apiKeyHeader = 'x-api-key';

  /// Header con el total de registros de un listado paginado.
  static const String paginationCountHeader = 'pagination-count';

  /// Tamaño de página del listado. 107 razas → 6 páginas.
  static const int pageSize = 20;

  /// Espera antes de disparar una búsqueda mientras el usuario escribe.
  static const Duration searchDebounce = Duration(milliseconds: 350);
}
