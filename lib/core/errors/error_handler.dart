import 'package:dio/dio.dart';
import 'package:base_flutter_ai/core/errors/exceptions.dart';
import 'package:base_flutter_ai/core/errors/failures.dart';
import 'package:base_flutter_ai/core/utils/logger.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Converts any exception/error into a domain [Failure].
  static Failure handle(dynamic error, [StackTrace? stackTrace]) {
    AppLogger.e('Error handled by ErrorHandler: $error', error, stackTrace);

    if (error is AppException) {
      return _mapAppExceptionToFailure(error);
    }

    if (error is DioException) {
      return _mapDioExceptionToFailure(error);
    }

    return UnknownFailure(
      message: error?.toString() ?? 'An unknown error occurred.',
    );
  }

  static Failure _mapAppExceptionToFailure(AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    }
    if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    }
    if (exception is UnauthorizedException || exception is ForbiddenException) {
      return AuthFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    }
    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    }
    if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    }
    return ServerFailure(
      message: exception.message,
      code: exception.statusCode,
    );
  }

  static Failure _mapDioExceptionToFailure(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        final responseData = dioException.response?.data;

        String message = 'Server returned error ($statusCode)';
        if (responseData is Map && responseData['message'] != null) {
          message = responseData['message'].toString();
        } else if (responseData is String && responseData.isNotEmpty) {
          message = responseData;
        }

        if (statusCode == 401 || statusCode == 403) {
          return AuthFailure(message: message, code: statusCode);
        }
        if (statusCode == 422) {
          return ValidationFailure(message: message, code: statusCode);
        }
        return ServerFailure(message: message, code: statusCode);

      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request was cancelled.');

      case DioExceptionType.badCertificate:
        return const NetworkFailure(
          message: 'Security certificate verification failed.',
        );

      case DioExceptionType.unknown:
      default:
        return NetworkFailure(
          message: dioException.message ?? 'Network connection error.',
        );
    }
  }
}
