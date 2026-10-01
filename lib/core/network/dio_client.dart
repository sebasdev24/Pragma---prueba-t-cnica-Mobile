import 'dart:io';

import 'package:catbreeds/core/errors/failure.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

/// Una capa delgada sobre [Dio] que nunca lanza. Si la request falla,
/// devuelve el [Failure] que corresponde; así los datasources no tienen que
/// saber nada de `DioException`.
class DioClient {
  final Dio _dio;

  DioClient(this._dio);

  Future<Either<Failure, Response<dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Es pública y estática para poder probarla sin crear un Dio.
  static Failure mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(error.message ?? 'Connection error');
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final data = error.response?.data;
        final message = data is Map && data['message'] is String
            ? data['message'] as String
            : 'HTTP $status';
        return ServerFailure(message, statusCode: status);
      case DioExceptionType.badCertificate:
        return const ServerFailure('Bad certificate');
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkFailure(error.message ?? 'Socket error');
        }
        return UnknownFailure(error.message ?? error.toString());
    }
  }
}
