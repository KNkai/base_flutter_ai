import 'package:dio/dio.dart';
import 'package:base_flutter_ai/core/utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d('--> ${options.method.toUpperCase()} ${options.uri}');
    if (options.headers.isNotEmpty) {
      AppLogger.d('Headers: ${options.headers}');
    }
    if (options.data != null) {
      AppLogger.d('Request Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.d('<-- ${response.statusCode} ${response.requestOptions.uri}');
    AppLogger.d('Response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}',
      err,
    );
    super.onError(err, handler);
  }
}
