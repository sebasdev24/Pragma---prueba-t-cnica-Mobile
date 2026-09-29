import 'dart:io';

import 'package:catbreeds/core/errors/failure.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

/// Envoltorio de [Dio] que nunca lanza: traduce cualquier error de red a un
/// [Failure] tipado. Los datasources solo ven `Either`.
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

  /// Público para poder probar el mapeo sin levantar Dio.
  static Failure mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return const CancelledFailure();
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
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkFailure(error.message ?? 'Socket error');
        }
        return UnknownFailure(error.message ?? error.toString());
    }
  }
}
