---
name: flutter-feature-development
description: "End-to-end workflow for designing and developing a new Flutter feature using Feature-First Clean Architecture and GetX. Activate when creating new application features, screens, or functional modules."
---

# Flutter Feature Development Workflow

This skill guides you through implementing complete, production-grade Flutter features following the project's standard Feature-First Clean GetX pattern.

## When to Activate
- The user requests a new feature (e.g., "Add a profile screen", "Implement product catalog").
- Creating a new vertical slice containing data, domain, and presentation components.

## Required Context Inspection
Before writing code:
1. Inspect `lib/features/` to check existing feature patterns and naming conventions.
2. Review `lib/core/` for shared infrastructure (`DioClient`, `StorageService`, `SafeParser`, core widgets).
3. Check `lib/app/routes/app_routes.dart` and `app_pages.dart` to determine route registration points.

## Step-by-Step Procedure

### 1. Create Feature Directory Structure
```
lib/features/<feature_name>/
├── domain/
│   ├── entities/<feature>_entity.dart
│   └── repositories/<feature>_repository.dart
├── data/
│   ├── models/<feature>_model.dart
│   ├── datasources/<feature>_remote_datasource.dart
│   └── repositories/<feature>_repository_impl.dart
└── presentation/
    ├── bindings/<feature>_binding.dart
    ├── controllers/<feature>_controller.dart
    ├── views/<feature>_view.dart
    └── widgets/
```

### 2. Implement Domain Layer
- Define pure Dart entity classes with `const` constructors, equality (`==`), and `hashCode`.
- Define the abstract repository interface returning `Future` or `Stream` of entities.

### 3. Implement Data Layer
- Define model classes with `json_serializable` or explicit `fromJson`/`toJson`.
- Always wrap nullable numbers and booleans with `SafeParser`.
- Implement datasource consuming `DioClient`.
- Implement repository, catching exceptions and delegating to `ErrorHandler.handle(e, st)`.

### 4. Implement Presentation Layer
- Implement `<Feature>Controller extends GetxController`:
  - Define observable state (`RxList`, `RxBool`, `RxnString`).
  - Implement action methods with try/catch/finally and loading state toggling.
- Implement `<Feature>Binding extends Bindings`:
  - Register datasource, repository, and controller with `Get.lazyPut()`.
- Implement `<Feature>View extends GetView<<Feature>Controller>`:
  - Compose UI using `Obx` for reactive parts.
  - Integrate `AppLoadingIndicator`, `AppErrorView`, `AppEmptyView`.

### 5. Register Named Route
- Add constant to `lib/app/routes/app_routes.dart`.
- Add `GetPage` entry with binding in `lib/app/routes/app_pages.dart`.

## Code Conventions
- Keep business logic strictly out of views.
- Views extend `GetView<TController>`.
- Use `const` widgets wherever possible.
- Run `dart run build_runner build` if models use `@JsonSerializable()`.

## Common Mistakes to Avoid
- Mixing UI state inside data models or domain entities.
- Calling `Dio` or `SharedPreferences` directly from controllers or views.
- Wrapping the entire `Scaffold` in an `Obx` (wrap only the dynamic widget trees).
- Forgetting to register the new binding in `AppPages`.

## Verification Checklist
- [ ] Domain entity contains no JSON or external framework dependencies.
- [ ] Safe numeric parsing is applied on model fields.
- [ ] Repository wraps errors with `ErrorHandler.handle`.
- [ ] Route is registered in `AppPages` with lazy-loaded binding.
- [ ] `flutter analyze` passes with 0 issues.
- [ ] Unit test written for controller and repository.

## Deliverables
- Complete feature slice under `lib/features/<feature_name>/`.
- Route registration in `AppRoutes` and `AppPages`.
- Unit tests under `test/features/<feature_name>/`.

