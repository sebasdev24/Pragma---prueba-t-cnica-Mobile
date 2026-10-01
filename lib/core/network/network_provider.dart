import 'package:catbreeds/core/config/env/env.dart';
import 'package:catbreeds/core/network/dio_client.dart';
import 'package:catbreeds/core/network/interceptors/api_key_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.addAll([
    ApiKeyInterceptor(Env.catApiKey),
    // Solo en builds de debug. Sin los headers, para que la x-api-key no
    // termine en el log.
    if (kDebugMode)
      LogInterceptor(
        requestHeader: false,
        responseBody: false,
        logPrint: (o) => debugPrint('$o'),
      ),
  ]);
  return dio;
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.watch(dioProvider));
});
