import 'package:catbreeds/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

/// Le pone el header `x-api-key` a todas las requests. La key sale del
/// `.env` (vía Envied), nunca del código.
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
