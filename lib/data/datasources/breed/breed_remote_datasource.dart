import 'package:catbreeds/core/constants/api_constants.dart';
import 'package:catbreeds/core/errors/exceptions.dart';
import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/core/network/dio_client.dart';
import 'package:catbreeds/data/models/breed/breed_model.dart';
import 'package:dio/dio.dart';

/// Resultado crudo de una página: modelos + total del header.
typedef BreedModelPage = ({List<BreedModel> items, int total});

/// Habla con The Cat API. Lanza [FailureException] con el [Failure] ya
/// tipado; el repositorio lo desenvuelve.
abstract class BreedRemoteDataSource {
  Future<BreedModelPage> getBreeds({required int page, required int limit});

  Future<List<BreedModel>> searchBreeds(String query);

  Future<BreedModel> getBreedById(String id);
}

class BreedRemoteDataSourceImpl implements BreedRemoteDataSource {
  final DioClient _dioClient;

  BreedRemoteDataSourceImpl(this._dioClient);

  @override
  Future<BreedModelPage> getBreeds({
    required int page,
    required int limit,
  }) async {
    final response = await _get(
      ApiConstants.breeds,
      query: {'page': page, 'limit': limit},
    );
    final items = _parseList(response.data);
    final header = response.headers.value(ApiConstants.paginationCountHeader);
    // Sin header no sabemos el total. Una página llena sugiere que puede
    // haber otra; una incompleta, que era la última.
    final loaded = page * limit + items.length;
    final total =
        int.tryParse(header ?? '') ??
        (items.length == limit ? loaded + 1 : loaded);
    return (items: items, total: total);
  }

  @override
  Future<List<BreedModel>> searchBreeds(String query) async {
    // `attach_image=1` hace que la búsqueda devuelva el objeto `image`,
    // igual que el listado. Sin él, cada card necesitaría otra request.
    final response = await _get(
      ApiConstants.breedsSearch,
      query: {'q': query, 'attach_image': 1},
    );
    return _parseList(response.data);
  }

  @override
  Future<BreedModel> getBreedById(String id) async {
    final response = await _get(ApiConstants.breedById(id));
    final data = response.data;
    if (data is Map<String, dynamic> && data['id'] is String) {
      return BreedModel.fromJson(data);
    }
    throw const FailureException(ServerFailure('Not found', statusCode: 404));
  }

  Future<Response<dynamic>> _get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final result = await _dioClient.get(path, queryParameters: query);
    return result.fold((f) => throw FailureException(f), (r) => r);
  }

  List<BreedModel> _parseList(Object? data) {
    if (data is! List) {
      throw const FailureException(ParsingFailure('Expected a JSON list'));
    }
    // Un registro malformado se descarta; no invalida el resto.
    final models = <BreedModel>[];
    for (final item in data) {
      if (item is Map<String, dynamic> &&
          item['id'] is String &&
          item['name'] is String) {
        models.add(BreedModel.fromJson(item));
      }
    }
    return models;
  }
}
