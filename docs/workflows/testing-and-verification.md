# Workflow: Testing & Verification

## 1. Overview
Covers test authoring, test execution, test mock generation, and continuous verification for Flutter applications.

## 2. Inputs
- Code under test (`controllers/`, `repositories/`, `datasources/`, `views/`, `utils/`).
- Test requirements and edge-case criteria.

## 3. Preconditions
- Dependencies installed via `flutter pub get`.
- `build_runner` and `mockito` configured in `dev_dependencies`.

## 4. Required Agents & Skills
- **Lead Agent**: `flutter-tester`
- **Supporting Agent**: `flutter-developer`
- **Relevant Skills**: `flutter-unit-testing`, `flutter-widget-testing`, `flutter-integration-testing`

## 5. Execution Steps

### Step 1: Generate Test Mocks (if needed)
Generate mock classes for external boundaries using Mockito:
```dart
import 'package:mockito/annotations.dart';
import 'package:base_flutter_ai/features/home/domain/repositories/post_repository.dart';

@GenerateMocks([PostRepository])
void main() {}
```
Generate with:
```powershell
dart run build_runner build --delete-conflicting-outputs
```

### Step 2: Implement Unit Tests
- Create tests under `test/unit/` or `test/features/<feature>/`.
- Assert state changes across: initial state -> loading state -> success/error state.

### Step 3: Implement Widget Tests
- Create tests under `test/widget/` or `test/features/<feature>/presentation/`.
- Test widget rendering across states using `WidgetTester`.
- Always include `Get.reset()` in `tearDown()`.

### Step 4: Run Complete Test Suite
```powershell
flutter test
```

## 6. Acceptance Criteria
- [ ] All unit and widget tests pass.
- [ ] No flaky asynchronous tests.
- [ ] No unhandled exceptions in test output.

## 7. Expected Outputs
- Comprehensive test files covering business logic and views.
- Clean test run output with 100% passing tests.

