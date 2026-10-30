# Production-Grade Flutter + AI Engineering Starter Kit

A production-grade, enterprise-ready Flutter Starter Kit integrated with a complete **AI Engineering System** (Specialized Agents, Skills, Rules, Workflows, and MCP Tooling) for Google Antigravity IDE and cross-platform AI coding assistants.

Built for scalability, high velocity, and architectural consistency across mobile, web, and desktop.

---

## 1. Core Technology Stack

| Capability | Technology | Standard Usage |
| :--- | :--- | :--- |
| **Framework** | **Flutter 3.47+ (Stable) / Dart 3.13+** | Multiplatform compilation with Dart 3 patterns & strict typing |
| **State Management** | **GetX** | Reactive state (`RxInt`, `RxBool`, `RxString`, `RxList`, `Obx`) |
| **Dependency Injection** | **GetX Bindings** | Route-level lifecycle management via `Get.lazyPut()` |
| **Navigation & Routing** | **GetX Named Routing** | Deep-link ready routes via `AppRoutes` and `AppPages` |
| **Networking** | **Dio** | Configurable `DioClient` with Auth, Logging, and Error interceptors |
| **Serialization** | **json_serializable & SafeParser** | Resilient numeric and boolean parsing immune to backend typing bugs |
| **Local Persistence** | **shared_preferences** | General application preferences and theme caching (`StorageService`) |
| **Secure Vault** | **flutter_secure_storage** | Hardware-backed encrypted vault for sensitive tokens (`SecureStorageService`) |
| **Tooling & Lints** | **flutter_lints + strict analysis** | Strict casts, strict inference, and strict raw types enforced |

---

## 2. Architecture: Feature-First Clean GetX

The project organizes code by business capability while maintaining strict Clean Architecture layer separation:

```
lib/
├── app/                  # Application root, routing, theming, and global bindings
│   ├── app.dart          # GetMaterialApp configuration
│   ├── bindings/         # Global bindings (InitialBinding)
│   ├── routes/           # AppRoutes constants & AppPages route registry
│   └── theme/            # AppTheme (Material 3 Light/Dark), AppColors, AppTypography
├── core/                 # Shared cross-cutting infrastructure (zero feature business logic)
│   ├── config/           # Multi-environment configuration (dev, staging, prod)
│   ├── constants/        # ApiEndpoints, StorageKeys, AppConstants
│   ├── errors/           # AppException, domain Failure, and ErrorHandler
│   ├── network/          # DioClient, AuthInterceptor, ErrorInterceptor, LoggingInterceptor
│   ├── storage/          # StorageService (shared_prefs) & SecureStorageService (secure_storage)
│   ├── utils/            # SafeParser, AppLogger, Formatters
│   └── widgets/          # AppLoadingIndicator, AppErrorView, AppEmptyView, AppButton, AppTextField
├── features/             # Self-contained business modules
│   └── home/             # Complete reference feature slice
│       ├── data/         # PostModel, PostRemoteDataSource, PostRepositoryImpl
│       ├── domain/       # PostEntity, PostRepository interface
│       └── presentation/ # HomeController, HomeBinding, HomeView, HomeHeader, PostCard
├── main.dart             # Default entrypoint (Development flavor)
├── main_common.dart      # Shared bootstrap runner
├── main_dev.dart         # Development environment runner
├── main_staging.dart     # Staging environment runner
└── main_prod.dart        # Production environment runner
```

---

## 3. Environments & Flavors

The project supports multi-environment builds without code modifications:

| Environment | Entrypoint | Default API URL | Logging |
| :--- | :--- | :--- | :--- |
| **Development** | `lib/main_dev.dart` | `https://jsonplaceholder.typicode.com` | Enabled |
| **Staging** | `lib/main_staging.dart` | `https://staging-api.example.com` | Enabled |
| **Production** | `lib/main_prod.dart` | `https://api.example.com` | Disabled |

Run target environment:
```powershell
flutter run -t lib/main_dev.dart
flutter run -t lib/main_staging.dart
flutter run -t lib/main_prod.dart
```

---

## 4. AI Engineering Subsystem

This repository embeds an autonomous AI system designed for **Google Antigravity IDE** and compatible with standard agent environments.

### A. Global Guidelines (`AGENTS.md`)
- Single source of truth for architectural constraints, coding conventions, forbidden libraries, and Definition of Done.

### B. Specialized Agents (`.agents/agents/`)
| Agent | Responsibility |
| :--- | :--- |
| **`flutter-architect`** | High-level system design, module boundaries, package vetting, and technical planning |
| **`flutter-developer`** | End-to-end feature implementation, GetX controllers, bindings, and bug fixing |
| **`flutter-ui-engineer`** | Responsive widget composition, design tokens, Material 3, and accessibility (WCAG) |
| **`flutter-reviewer`** | Code quality auditing, architecture conformance, security checks, and PR reviews |
| **`flutter-tester`** | Unit testing, widget testing, mock generation with Mockito, and regression verification |
| **`flutter-api-engineer`** | Dio client orchestration, interceptors, resilient serialization, and error recovery |

### C. Specialized Skills (`.agents/skills/`)
16 production runbooks providing step-by-step procedures, code patterns, common mistakes, and checklists:
- `flutter-feature-development`: Vertical-slice feature development procedure
- `flutter-architecture-design`: Clean Architecture and boundary definition
- `flutter-getx-patterns`: Idiomatic reactive state management and named routing
- `flutter-api-integration`: Connecting features to RESTful APIs
- `flutter-dio-networking`: Dio client, interceptors, timeouts, and headers
- `flutter-json-model-generation`: Safe numeric parsing with `SafeParser` & `build_runner`
- `flutter-ui-implementation`: Composable, accessible, and const-optimized widgets
- `flutter-responsive-design`: Adaptive layouts across mobile, tablet, and desktop
- `flutter-debugging`: Root-cause diagnosis and surgical bug repair
- `flutter-code-review`: Pull request and code quality audits
- `flutter-unit-testing`: Unit testing controllers, repositories, and utilities
- `flutter-widget-testing`: Component and screen-level widget testing
- `flutter-integration-testing`: End-to-end application user flows
- `flutter-performance-optimization`: Frame rate tuning, rebuild scoping, and memory profiling
- `flutter-security-review`: Secret audit, TLS enforcement, and secure storage verification
- `flutter-release-management`: Version bumping, flavor builds, and release bundles

### D. Targeted Rules (`.agents/rules/`)
Ten modular rules automatically loaded by Antigravity:
1. `01-architecture.md`: Feature-First layers and domain purity
2. `02-getx.md`: Controller scoping, bindings, and named routing
3. `03-dart-coding-conventions.md`: Strict types, const constructors, logging
4. `04-models-and-serialization.md`: Mandatory `SafeParser` usage and entity mapping
5. `05-networking-and-dio.md`: Dio client standards and centralized error handling
6. `06-ui-and-responsive-design.md`: Breakpoint conventions and standard UI widgets
7. `07-testing.md`: Coverage standards and `Get.reset()` teardown discipline
8. `08-security.md`: Secure token vault and secret isolation
9. `09-dependencies.md`: Approved tech stack and forbidden alternatives
10. `10-git-and-code-review.md`: Conventional commits and pre-commit gates

### E. Model Context Protocol (MCP)
- Configured in `.agents/mcp_config.json` utilizing the official Dart MCP server (`dart mcp-server`).
- Exposes Dart analyzer diagnostics, formatting, package search, and runtime introspection to Antigravity.

---

## 5. Development Workflows (`docs/workflows/`)

Structured workflows covering the end-to-end software lifecycle:
1. `new-project-initialization.md`: New application setup and renaming
2. `feature-development.md`: Step-by-step vertical slice development
3. `api-integration.md`: Backend endpoint integration
4. `bug-investigation-and-fixing.md`: Systematic debugging and regression testing
5. `code-review.md`: Quality and architectural audit
6. `testing-and-verification.md`: Comprehensive test authoring and execution
7. `release-preparation.md`: Versioning, flavor building, and store packaging

---

## 6. Automation Scripts (`scripts/`)

### Bootstrap New Project
Quickly customize this starter kit for a new project:
```powershell
.\scripts\bootstrap.ps1 -ProjectName "my_new_app" -AppTitle "My New App" -Org "com.mycompany"
```

### Automated Quality Validation
Run formatting check, static code analysis, and the automated test suite in one command:
```powershell
.\scripts\validate.ps1
```
Automatically fix formatting if needed:
```powershell
.\scripts\validate.ps1 -FixFormat
```

---

## 7. Testing Suite

The starter kit comes with comprehensive unit and widget tests:
```powershell
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

Test coverage includes:
- `SafeParser`: Null safety, string-to-number conversions, fallback resilience.
- `ErrorHandler`: Typed `AppException` and `DioException` mapping to domain `Failure`.
- `PostModel`: JSON serialization, entity conversion, and resilient parsing.
- `HomeController`: Reactive loading states, data assignment, error handling, search queries.
- `HomeView`: Screen rendering, loading indicators, error views with retry callbacks, post cards.
- `Core Widgets`: `AppButton`, `AppErrorView`, `AppEmptyView`, `AppLoadingIndicator`.
- `App Root`: Application mounting and dependency container smoke tests.

---

## 8. Creating a New Project from this Template

Bạn có thể tạo một dự án mới hoàn chỉnh từ base template này chỉ với **1 câu lệnh duy nhất** mà không cần phải đi vào từng file đổi thủ công.

### Cách 1: Chạy 1 dòng lệnh duy nhất từ bất kỳ thư mục nào (Khuyên dùng)

Mở PowerShell tại thư mục bạn muốn lưu dự án mới và chạy:

```powershell
git clone https://github.com/KNkai/base_flutter_ai.git my_app; cd my_app; .\scripts\bootstrap.ps1 -ProjectName "my_app" -AppTitle "My App Title" -Org "com.mycompany" -ResetGit
```

> **Giải thích tham số:**
> - `-ProjectName`: Tên package Dart (`snake_case`, ví dụ: `my_app`, `food_delivery`).
> - `-AppTitle`: Tên hiển thị của app trên màn hình điện thoại (ví dụ: `"My App Title"`).
> - `-Org`: Domain công ty để sinh Bundle ID (ví dụ: `"com.mycompany"` $\to$ ID sẽ là `com.mycompany.my_app`).
> - `-ResetGit`: Tự động ngắt remote của template gốc, khởi tạo `git init` mới và tạo initial commit cho repo mới của bạn.

---

### Cách 2: Dùng script `create_app.ps1`

Nếu bạn đã có sẵn script hoặc muốn chạy thông qua script điều hướng:

```powershell
.\scripts\create_app.ps1 -ProjectName "my_app" -AppTitle "My App Title" -Org "com.mycompany"
```

---

### Cách 3: Cài đặt lệnh tắt toàn cục (`nfa`) gõ siêu nhanh

Để có thể mở terminal ở bất kỳ đâu trên máy tính và chỉ cần gõ `nfa <tên_app>`:

1. Mở PowerShell và gõ:
   ```powershell
   notepad $PROFILE
   ```
2. Dán đoạn function sau vào cuối file rồi lưu lại:
   ```powershell
   function New-FlutterApp {
       param(
           [Parameter(Mandatory=$true, Position=0)][string]$Name,
           [Parameter(Position=1)][string]$Title = $Name,
           [Parameter(Position=2)][string]$Org = "com.example"
       )
       $repo = "https://github.com/KNkai/base_flutter_ai.git"
       Write-Host "Cloning base project into $Name..." -ForegroundColor Cyan
       git clone $repo $Name
       Set-Location $Name
       powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap.ps1 -ProjectName $Name -AppTitle $Title -Org $Org -ResetGit
   }
   Set-Alias nfa New-FlutterApp
   ```
3. Khởi động lại terminal. Từ giờ bạn chỉ cần gõ:
   ```powershell
   nfa food_delivery "Food Delivery App" com.company
   ```

---

### Những gì hệ thống tự động thiết lập cho bạn:

| Nền tảng / Thành phần | Tác vụ tự động |
| :--- | :--- |
| **Dart & Pubspec** | Đổi `name:` trong `pubspec.yaml`, quét và đổi toàn bộ `package:base_flutter_ai/` $\to$ `package:<tên_mới>/` trong `lib/` và `test/`. |
| **App Title** | Cập nhật `appTitle` trong `lib/main_dev.dart`, `lib/main_staging.dart`, `lib/main_prod.dart`. |
| **Android** | Đổi `namespace` & `applicationId` trong `android/app/build.gradle.kts`, đổi `android:label` trong `AndroidManifest.xml`. |
| **iOS** | Đổi `CFBundleDisplayName` & `CFBundleName` trong `Info.plist`, đổi `PRODUCT_BUNDLE_IDENTIFIER` trong Xcode `project.pbxproj`. |
| **Web & Windows** | Đổi `<title>` và meta trong `web/index.html` & `manifest.json`; đổi `BINARY_NAME` và `ProductName` trong Windows runner. |
| **Git Version Control** | Xóa lịch sử git base, chạy `git init`, `git add .`, tạo initial commit mới toanh sẵn sàng push lên GitHub riêng. |
| **Dependencies & Build** | Tự động chạy `flutter pub get`, `dart run build_runner build`, và chạy `validate.ps1` kiểm tra sức khỏe dự án. |
