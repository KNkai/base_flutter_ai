# Coding Standards & Guidelines

## 1. Technology Enforcement
- **State Management**: Only **GetX** (`GetxController`, `Rx`, `Obx`). Do not introduce Riverpod, Bloc, or Provider.
- **Dependency Injection**: Only **GetX** `Bindings` and `Get.lazyPut()`.
- **Routing**: Only **GetX Named Routing** via `AppRoutes` and `AppPages`.
- **Networking**: Only **Dio** via `DioClient`. Do not introduce `package:http`.

## 2. Model & Serialization Standards
- Every model must implement `toEntity()`.
- For any nullable numeric or boolean fields from APIs, use `SafeParser`:
  - `SafeParser.toDouble(json['amount'])`
  - `SafeParser.toInt(json['count'])`
  - `SafeParser.toBool(json['active'])`

## 3. Presentation Standards
- Views must extend `GetView<TController>`.
- Keep business logic outside widgets.
- Mark constructors `const` whenever possible.
- Use `Obx` scoped only to the widgets that display dynamic reactive data.

## 4. Error Handling
- Never expose raw exceptions to presentation or domain layers.
- Always map exceptions to `Failure` objects using `ErrorHandler.handle(e, st)`.
- Display errors to users using `AppErrorView` with a retry callback.

## 5. Security Standards
- Authentication tokens must be saved exclusively via `SecureStorageService` (`flutter_secure_storage`).
- Non-sensitive user preferences are stored in `StorageService` (`shared_preferences`).
- Never commit secrets or API tokens to source control.

