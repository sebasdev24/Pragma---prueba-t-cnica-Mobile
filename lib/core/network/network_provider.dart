import 'package:catbreeds/core/config/app_config.dart';
import 'package:catbreeds/core/network/dio_client.dart';
import 'package:catbreeds/core/network/interceptors/api_key_interceptor.dart';
import 'package:catbreeds/core/network/interceptors/retry_interceptor.dart';
import 'package:catbreeds/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// Crea el [Dio] de la app con sus interceptores.
///
/// El orden importa: la request recorre la lista de arriba abajo y la
/// respuesta de abajo arriba.
///   1. RetryInterceptor: solo reintenta GETs.
///   2. ApiKeyInterceptor: agrega `x-api-key`.
///   3. TalkerDioLogger: va último para ver los headers finales.
Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    RetryInterceptor(dio: dio),
    ApiKeyInterceptor(AppConfig.catApiKey),
    if (AppConfig.enableDebugTools)
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printResponseData: false,
          printRequestHeaders: false,
          printResponseHeaders: false,
        ),
      ),
  ]);

  return dio;
}

final dioProvider = Provider<Dio>((ref) => createDio());

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.watch(dioProvider));
});
