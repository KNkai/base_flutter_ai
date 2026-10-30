# System Architecture Overview

`base_flutter_ai` is structured using **Feature-First Clean Architecture** coupled with **GetX** for fine-grained reactive state management and dependency injection, and **Dio** for resilient HTTP networking.

```
┌───────────────────────────────────────────────────────────────┐
│                      Presentation Layer                       │
│  - GetView<TController>                                       │
│  - GetxController (Reactive Rx state, actions, lifecycles)   │
│  - Bindings (Get.lazyPut route-level dependency injection)    │
│  - Responsive Layouts (LayoutBuilder, Mobile/Tablet grid)     │
└──────────────────────────────┬────────────────────────────────┘
                               │ calls
┌──────────────────────────────▼────────────────────────────────┐
│                        Domain Layer                           │
│  - Pure Dart Entities (PostEntity)                            │
│  - Abstract Repository Interfaces (PostRepository)            │
│  - Pure business logic & contracts (Zero Flutter dependencies)│
└──────────────────────────────▲────────────────────────────────┘
                               │ implements
┌──────────────────────────────┴────────────────────────────────┐
│                         Data Layer                            │
│  - Data Models (PostModel with json_serializable & SafeParser)│
│  - Remote Data Sources (PostRemoteDataSource via DioClient)   │
│  - Repository Implementations (PostRepositoryImpl)            │
│  - Error mapping (delegates exceptions to ErrorHandler)       │
└──────────────────────────────┬────────────────────────────────┘
                               │ utilizes
┌──────────────────────────────▼────────────────────────────────┐
│                     Core Infrastructure                       │
│  - DioClient & Interceptors (Auth, Error, Logging)            │
│  - StorageService (SharedPreferences)                         │
│  - SecureStorageService (FlutterSecureStorage)                │
│  - SafeParser (Type resilience & null safety)                 │
│  - Reusable UI States (Loading, Error, Empty views)           │
└───────────────────────────────────────────────────────────────┘
```

## Layer Responsibilities

### 1. `lib/app/`
Contains application bootstrapping and global orchestration:
- `app.dart`: `GetMaterialApp` root configuration with themes and routing.
- `routes/`: Named route strings (`AppRoutes`) and route definitions (`AppPages`).
- `theme/`: Material 3 themes, color palettes (`AppColors`), and typography (`AppTypography`).
- `bindings/`: Application-level dependencies (`InitialBinding`).

### 2. `lib/core/`
Shared cross-cutting capabilities with zero feature business logic:
- `config/`: Environment flavors (`dev`, `staging`, `prod`) and timeouts.
- `constants/`: API paths, storage keys, and design tokens.
- `errors/`: Typed `AppException`, domain `Failure`, and `ErrorHandler`.
- `network/`: `DioClient`, `AuthInterceptor`, `ErrorInterceptor`, `LoggingInterceptor`.
- `storage/`: `StorageService` and `SecureStorageService`.
- `utils/`: `SafeParser`, `AppLogger`, `Formatters`.
- `widgets/`: `AppLoadingIndicator`, `AppErrorView`, `AppEmptyView`, `AppButton`, `AppTextField`.

### 3. `lib/features/<name>/`
Vertical feature slices:
- `domain/`: Business entities and repository contracts.
- `data/`: JSON models, remote datasources, and repository implementations.
- `presentation/`: GetX controllers, bindings, views, and feature-specific widgets.

