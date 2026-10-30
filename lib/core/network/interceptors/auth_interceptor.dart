import 'package:dio/dio.dart';
import 'package:base_flutter_ai/core/constants/storage_keys.dart';
import 'package:base_flutter_ai/core/storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Exclude auth header if requested
    if (options.extra['requiresAuth'] == false) {
      return handler.next(options);
    }

    final token = await _secureStorage.read(StorageKeys.authToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
