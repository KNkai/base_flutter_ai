/// Base class for application-level exceptions.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AppException({required this.message, this.statusCode, this.details});

  @override
  String toString() => '$runtimeType: $message (statusCode: $statusCode)';
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection or network unreachable.',
    super.statusCode,
    super.details,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'The connection has timed out. Please try again.',
    super.statusCode,
    super.details,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized access. Please log in again.',
    super.statusCode = 401,
    super.details,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'You do not have permission to access this resource.',
    super.statusCode = 403,
    super.details,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Requested resource was not found.',
    super.statusCode = 404,
    super.details,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.statusCode = 422,
    super.details,
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Failed to read or write local cache data.',
    super.statusCode,
    super.details,
  });
}
