# Rule 05: Networking & Dio Standards

1. **Client Standard**:
   - All HTTP communication must go through `DioClient`.
   - Never import or use `package:http` or raw `dart:io` `HttpClient`.
2. **Endpoints & Query Parameters**:
   - All API paths must be declared as static constants in `ApiEndpoints`.
   - Use `queryParameters: {}` rather than string concatenation when passing query arguments.
3. **Interception & Error Handling**:
   - Authentication tokens are automatically injected by `AuthInterceptor`.
   - Errors are intercepted by `ErrorInterceptor` and converted to `AppException`.
   - Repositories must catch errors and convert them to domain `Failure`s using `ErrorHandler.handle(e, st)`.
4. **Environment Awareness**:
   - Host URLs and timeouts are read from `AppConfig.environment`. Never hardcode base URLs in datasources.

