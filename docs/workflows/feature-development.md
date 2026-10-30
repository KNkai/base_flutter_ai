# Workflow: Feature Development

## 1. Overview
Defines the standard vertical-slice development process for implementing a new feature in the application using Feature-First Clean GetX architecture.

## 2. Inputs
- Feature requirements and functional specifications.
- UI wireframes or design tokens.
- API specifications (endpoints, request/response JSON contracts).

## 3. Preconditions
- Project initialized and passing `validate.ps1`.
- Clean Git working tree on a feature branch (`feature/<name>`).

## 4. Required Agents & Skills
- **Lead Agent**: `flutter-developer`
- **Supporting Agents**: `flutter-ui-engineer`, `flutter-api-engineer`, `flutter-tester`
- **Relevant Skills**: `flutter-feature-development`, `flutter-getx-patterns`, `flutter-ui-implementation`, `flutter-unit-testing`

## 5. Execution Steps

### Step 1: Design Domain Layer
1. Create `lib/features/<feature>/domain/entities/<feature>_entity.dart`.
2. Create `lib/features/<feature>/domain/repositories/<feature>_repository.dart`.
3. Keep domain free of Flutter and serialization packages.

### Step 2: Implement Data Layer
1. Create `lib/features/<feature>/data/models/<feature>_model.dart` with `@JsonSerializable()` and `SafeParser`.
2. Run code generation:
   ```powershell
   dart run build_runner build --delete-conflicting-outputs
   ```
3. Implement `lib/features/<feature>/data/datasources/<feature>_remote_datasource.dart`.
4. Implement `lib/features/<feature>/data/repositories/<feature>_repository_impl.dart` with `ErrorHandler.handle(e, st)`.

### Step 3: Implement Presentation Layer
1. Implement `lib/features/<feature>/presentation/controllers/<feature>_controller.dart`.
2. Implement `lib/features/<feature>/presentation/bindings/<feature>_binding.dart`.
3. Build responsive UI in `lib/features/<feature>/presentation/views/<feature>_view.dart`.

### Step 4: Register Route & Navigation
1. Add route constant to `lib/app/routes/app_routes.dart`.
2. Add `GetPage` entry with binding in `lib/app/routes/app_pages.dart`.

### Step 5: Test and Verify
1. Write unit tests for controller and repository under `test/features/<feature>/`.
2. Write widget test for the view.
3. Run `.\scripts\validate.ps1`.

## 6. Acceptance Criteria
- [ ] Feature follows domain -> data -> presentation structure.
- [ ] Business logic isolated in `GetxController`.
- [ ] Safe numeric parsing verified on model fields.
- [ ] All tests pass and analyzer reports 0 issues.

## 7. Expected Outputs
- New self-contained feature directory under `lib/features/<feature>/`.
- Registered route in `AppPages`.
- Automated tests covering the feature.

