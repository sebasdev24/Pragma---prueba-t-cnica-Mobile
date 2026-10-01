/// Endpoints y parámetros que usamos de The Cat API
/// (https://developers.thecatapi.com/).
class ApiConstants {
  const ApiConstants._();

  static const String breeds = '/breeds';
  static const String breedsSearch = '/breeds/search';
  static String breedById(String id) => '/breeds/$id';

  static const String apiKeyHeader = 'x-api-key';

  static const String paginationCountHeader = 'pagination-count';

  static const int pageSize = 20;

  static const Duration searchDebounce = Duration(milliseconds: 350);
}
