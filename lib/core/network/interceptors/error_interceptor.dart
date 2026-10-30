import 'package:dio/dio.dart';
import 'package:base_flutter_ai/core/errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException appException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        appException = TimeoutException(
          message: err.message ?? 'Network request timed out.',
          statusCode: err.response?.statusCode,
        );
        break;

      case DioExceptionType.connectionError:
        appException = NetworkException(
          message:
              err.message ?? 'Connection error. Check internet connection.',
          statusCode: err.response?.statusCode,
        );
        break;

      case DioExceptionType.badResponse:
        final status = err.response?.statusCode;
        final data = err.response?.data;
        String msg = 'Server returned $status';
        if (data is Map && data['message'] != null) {
          msg = data['message'].toString();
        } else if (data is String && data.isNotEmpty) {
          msg = data;
        }

        if (status == 401) {
          appException = UnauthorizedException(
            message: msg,
            statusCode: status,
          );
        } else if (status == 403) {
          appException = ForbiddenException(message: msg, statusCode: status);
        } else if (status == 404) {
          appException = NotFoundException(message: msg, statusCode: status);
        } else if (status == 422) {
          appException = ValidationException(message: msg, statusCode: status);
        } else {
          appException = ServerException(
            message: msg,
            statusCode: status,
            details: data,
          );
        }
        break;

      case DioExceptionType.cancel:
        appException = const ServerException(message: 'Request was cancelled.');
        break;

      case DioExceptionType.badCertificate:
        appException = const NetworkException(
          message: 'Invalid SSL certificate.',
        );
        break;

      case DioExceptionType.unknown:
      default:
        appException = NetworkException(
          message: err.message ?? 'Unknown network error.',
        );
        break;
    }

    // Attach mapped AppException to DioException error property
    final customErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: appException,
      message: appException.message,
    );

    handler.next(customErr);
  }
}
