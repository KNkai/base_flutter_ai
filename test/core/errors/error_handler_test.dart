import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:base_flutter_ai/core/errors/error_handler.dart';
import 'package:base_flutter_ai/core/errors/exceptions.dart';
import 'package:base_flutter_ai/core/errors/failures.dart';

void main() {
  group('ErrorHandler Tests', () {
    test('handles NetworkException -> NetworkFailure', () {
      const exception = NetworkException(message: 'No internet');
      final failure = ErrorHandler.handle(exception);

      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'No internet');
    });

    test('handles TimeoutException -> TimeoutFailure', () {
      const exception = TimeoutException(message: 'Connection timed out');
      final failure = ErrorHandler.handle(exception);

      expect(failure, isA<TimeoutFailure>());
      expect(failure.message, 'Connection timed out');
    });

    test('handles UnauthorizedException -> AuthFailure', () {
      const exception = UnauthorizedException(message: 'Invalid token');
      final failure = ErrorHandler.handle(exception);

      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'Invalid token');
      expect(failure.code, 401);
    });

    test('handles DioException connectionTimeout -> TimeoutFailure', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );
      final failure = ErrorHandler.handle(dioException);

      expect(failure, isA<TimeoutFailure>());
    });

    test('handles DioException badResponse 401 -> AuthFailure', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'message': 'Unauthorized request'},
        ),
      );
      final failure = ErrorHandler.handle(dioException);

      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'Unauthorized request');
      expect(failure.code, 401);
    });

    test('handles unknown generic exceptions -> UnknownFailure', () {
      final failure = ErrorHandler.handle('Arbitrary crash string');
      expect(failure, isA<UnknownFailure>());
      expect(failure.message, contains('Arbitrary crash string'));
    });
  });
}
