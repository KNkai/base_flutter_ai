---
name: flutter-dio-networking
description: "Configuring, intercepting, and optimizing Dio HTTP networking in Flutter. Activate when customizing Dio interceptors, authentication headers, retry policies, logging, or handling network timeouts."
---

# Flutter Dio Networking Guide

This skill details how to configure, extend, and debug Dio HTTP requests across environments.

## When to Activate
- Setting up custom Dio interceptors (auth token refresh, caching headers, telemetry).
- Adjusting connection and receive timeouts.
- Debugging network failures, SSL handshake issues, or bad responses.

## Core Components in `lib/core/network/`
1. **`DioClient`**: Central singleton wrapping `Dio` instance with base configurations.
2. **`AuthInterceptor`**: Automatically attaches `Authorization: Bearer <token>` from `SecureStorageService`.
3. **`ErrorInterceptor`**: Catches `DioException` and converts transport errors into typed `AppException`.
4. **`LoggingInterceptor`**: Prints formatted method, URL, headers, and payload logs in debug mode.

## Customizing Interceptors
To add a custom header or retry mechanism:
```dart
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 2});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    var retries = err.requestOptions.extra['retries'] ?? 0;
    if (retries < maxRetries && err.type == DioExceptionType.connectionTimeout) {
      err.requestOptions.extra['retries'] = retries + 1;
      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (_) {}
    }
    super.onError(err, handler);
  }
}
```

## Environment Switching
Timeouts and base URLs are defined per environment in `lib/core/config/env_config.dart`.
Never hardcode API host strings inside individual datasources.

## Verification Checklist
- [ ] No raw `http` package is imported.
- [ ] All network communication flows through `DioClient`.
- [ ] Requests respect environment base URL.

