import 'package:catbreeds/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

/// Agrega `x-api-key` a cada request. La key vive en el `.env` del entorno
/// (Envied, ofuscada) y nunca en el código.
class ApiKeyInterceptor extends Interceptor {
  final String apiKey;

  ApiKeyInterceptor(this.apiKey);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (apiKey.isNotEmpty) {
      options.headers[ApiConstants.apiKeyHeader] = apiKey;
    }
    handler.next(options);
  }
}
