# Base Flutter AI Starter Kit — AI Agent System Guidelines

## 1. Project Identity & Purpose
`base_flutter_ai` is a standardized, production-grade Flutter Starter Kit with an integrated AI Engineering System. It serves as an architectural template and pair-programming accelerator for building scalable Flutter mobile, desktop, and web applications.

Every agent working on this codebase must adhere strictly to these architectural patterns, state management practices, coding standards, and verification guidelines.

---

## 2. Technology Stack & Strict Boundaries

| Component | Standard Technology | Prohibited Alternatives (Do Not Introduce) |
| :--- | :--- | :--- |
| **Framework** | Flutter Stable (3.47+) / Dart 3.13+ | Outdated pre-Dart 3 syntax |
| **State Management** | **GetX** (`GetxController`, `Rx`, `Obx`, `GetView`) | Riverpod, Bloc, Provider, MobX |
| **Dependency Injection**| **GetX** (`Bindings`, `Get.put`, `Get.lazyPut`, `Get.find`) | injectable, kiwi, get_it |
| **Routing & Navigation**| **GetX Named Routing** (`GetPage`, `Get.toNamed`, `AppPages`) | GoRouter, AutoRoute, Beamer |
| **Networking** | **Dio** (`DioClient`, interceptors, centralized error handler) | `package:http`, raw HttpClient |
| **Local Storage** | `shared_preferences` (settings) & `flutter_secure_storage` (tokens) | Hive, Isar, Realm (unless explicitly requested) |
| **Serialization** | `json_serializable` + resilient `SafeParser` | Untyped dynamic Maps in domain/UI |

---

## 3. Architecture Overview (Feature-First Clean GetX)

The repository follows a **Feature-First Clean Architecture** with three core conceptual layers:
```
lib/
├── app/                  # Application-wide routing, theme, root bindings, and app entry
│   ├── app.dart
│   ├── bindings/
│   ├── routes/
│   └── theme/
├── core/                 # Shared cross-cutting infrastructure (zero feature business logic)
│   ├── config/           # Multi-environment configuration (dev, staging, prod)
│   ├── constants/        # API endpoints, storage keys, design constants
│   ├── errors/           # Typed AppExceptions, Domain Failures, and ErrorHandler
│   ├── network/          # Dio client, auth/logging/error interceptors, API responses
│   ├── storage/          # SharedPreferences & FlutterSecureStorage services
│   ├── utils/            # SafeParser, AppLogger, formatters
│   └── widgets/          # Reusable design system widgets (buttons, loaders, error/empty views)
└── features/             # Self-contained business modules
    └── [feature_name]/
        ├── data/         # Models (JSON), datasources (Dio API calls), repository implementations
        ├── domain/       # Pure Dart entities and abstract repository contracts
        └── presentation/ # GetxControllers, Views (GetView), Bindings, and local sub-widgets
```

### Architectural Principles:
1. **Separation of Concerns**: Never place API calls, storage access, or data parsing inside Flutter widgets.
2. **Business Logic in Controllers**: Controllers hold observable state (`Rx`) and coordinate use cases or repository operations.
3. **Pure Domain Entities**: Entities in `domain/` must be pure Dart classes free from JSON annotations or platform dependencies.
4. **Resilient Data Parsing**: Always use `SafeParser` for nullable numeric or boolean fields (e.g., `SafeParser.toDouble`, `SafeParser.toInt`).

---

## 4. Instruction Priorities for Agents

When resolving requests, prioritize instructions in this exact order:
1. **User Request**: Explicit parameters and scope stated by the user.
2. **`AGENTS.md` & `.agents/rules/*`**: Project architecture, constraints, and coding standards.
3. **Specialized Skills (`.agents/skills/*`)**: Execution runbooks and procedures.
4. **General Antigravity Guidelines & Best Practices**: Clean code, minimal diffs, comprehensive testing.

---

## 5. Coding Standards & Conventions

### Dart Conventions:
- Follow official Dart style and effective Dart conventions.
- Explicit type declarations for public APIs and return types.
- Pattern matching and switch expressions for exhaustiveness.
- Use `const` constructors wherever possible to optimize Flutter widget rebuilds.
- Avoid raw `print()`. Use `AppLogger.d()`, `AppLogger.i()`, or `AppLogger.e()`.

### GetX Conventions:
- Views must extend `GetView<TController>` when binding to a single controller.
- Use `Obx(() => ...)` only around widgets that observe reactive variables. Do not wrap entire scaffolds in `Obx`.
- Bindings must be defined for every route in `AppPages`.
- Prefer `Get.lazyPut()` within route bindings to ensure controllers are memory-managed and disposed when pages are popped.

### Networking & Serialization:
- Never call Dio directly from presentation or controllers.
- Routes: `Controller -> Repository -> DataSource -> DioClient`.
- All network exceptions must pass through `ErrorHandler.handle()` to return clean domain `Failure` objects.
- Model classes must implement `toEntity()` to separate network schema from application domain logic.

---

## 6. Security Requirements

- Never hardcode API keys, secrets, or JWT tokens in Dart code or repository commits.
- Store sensitive auth tokens exclusively in `SecureStorageService` (`flutter_secure_storage`).
- Store non-sensitive preferences (e.g. theme mode, language) in `StorageService` (`shared_preferences`).
- Always validate SSL certificates and sanitize user input before sending to backend APIs.

---

## 7. Testing Requirements

Every new feature or bug fix must include corresponding tests:
1. **Unit Tests** (`test/unit/...` or `test/features/...`):
   - Test `GetxController` business logic and state transitions.
   - Test `Repository` and `DataSource` with mock Dio client / mock datasources.
   - Test utility functions, especially `SafeParser`.
2. **Widget Tests** (`test/widget/...`):
   - Test presentation views in loading, error, empty, and populated states.
   - Verify user interactions (buttons, pull-to-refresh, inputs).
3. **Target**: Zero test failures, zero lint warnings under `flutter analyze`.

---

## 8. Agent Execution Workflow

```
[User Request]
       │
       ▼
1. Analyze Context & Architectural Rules
       │
       ▼
2. Select & Activate Relevant Skills
       │
       ▼
3. Implement Domain -> Data -> Presentation
       │
       ▼
4. Run Code Generation (if models modified)
       │
       ▼
5. Write Unit & Widget Tests
       │
       ▼
6. Run Verification (`validate.ps1` or `flutter analyze && flutter test`)
       │
       ▼
7. Deliver Verified Solution
```

---

## 9. Definition of Done (DoD)

A task or feature is only complete when:
- [ ] Code strictly follows Feature-First Clean GetX architecture.
- [ ] No forbidden packages (Riverpod, Bloc, `package:http`) were introduced.
- [ ] Safe numeric parsing (`SafeParser`) is applied to models.
- [ ] `dart format .` passes without formatting changes.
- [ ] `flutter analyze` reports **0 issues**.
- [ ] `flutter test` passes with **100% green tests**.
- [ ] All new files and symbols are properly documented.

