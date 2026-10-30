import 'package:dio/dio.dart';
import 'package:base_flutter_ai/core/config/app_config.dart';
import 'package:base_flutter_ai/core/network/interceptors/auth_interceptor.dart';
import 'package:base_flutter_ai/core/network/interceptors/error_interceptor.dart';
import 'package:base_flutter_ai/core/network/interceptors/logging_interceptor.dart';
import 'package:base_flutter_ai/core/storage/secure_storage_service.dart';

class DioClient {
  late final Dio dio;

  DioClient({Dio? customDio, SecureStorageService? secureStorage}) {
    if (customDio != null) {
      dio = customDio;
    } else {
      final env = AppConfig.environment;
      dio = Dio(
        BaseOptions(
          baseUrl: env.apiBaseUrl,
          connectTimeout: env.connectTimeout,
          receiveTimeout: env.receiveTimeout,
          sendTimeout: env.connectTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Add Interceptors
      if (secureStorage != null) {
        dio.interceptors.add(AuthInterceptor(secureStorage));
      }
      dio.interceptors.add(ErrorInterceptor());
      if (env.enableLogging) {
        dio.interceptors.add(LoggingInterceptor());
      }
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
