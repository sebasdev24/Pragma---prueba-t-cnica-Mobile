import 'dart:io';

import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _error(
  DioExceptionType type, {
  int? status,
  Object? data,
  Object? error,
}) {
  final options = RequestOptions(path: '/breeds');
  return DioException(
    requestOptions: options,
    type: type,
    error: error,
    response: status == null
        ? null
        : Response(requestOptions: options, statusCode: status, data: data),
  );
}

void main() {
  group('DioClient.mapDioError', () {
    test('timeouts y errores de conexión son NetworkFailure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ]) {
        expect(DioClient.mapDioError(_error(type)), isA<NetworkFailure>());
      }
    });

    test('SocketException sin tipo también es NetworkFailure', () {
      final failure = DioClient.mapDioError(
        _error(DioExceptionType.unknown, error: const SocketException('x')),
      );
      expect(failure, isA<NetworkFailure>());
    });

    test('respuesta 4xx/5xx conserva status y mensaje de la API', () {
      final failure = DioClient.mapDioError(
        _error(
          DioExceptionType.badResponse,
          status: 403,
          data: {'message': 'Invalid key'},
        ),
      );
      expect(failure, const ServerFailure('Invalid key', statusCode: 403));
      expect(failure.userMessage, contains('authenticate'));
    });
  });
}
