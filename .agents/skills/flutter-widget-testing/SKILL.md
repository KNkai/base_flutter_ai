---
name: flutter-widget-testing
description: "Authoring component-level and screen-level widget tests using WidgetTester. Activate when verifying UI rendering, user interaction (tap, scroll, enter text), and loading/error/empty visual states."
---

# Flutter Widget Testing Guide

This skill governs testing UI widgets and full screens in headless isolation using `WidgetTester`.

## When to Activate
- Writing widget tests for screens (`HomeView`, etc.).
- Testing core UI components (`AppButton`, `AppErrorView`, `AppEmptyView`).
- Verifying UI responsiveness to controller state changes.

## Best Practices for GetX Widget Tests
1. **Wrap in `GetMaterialApp`**: Ensure navigation context and theme data are available.
2. **Inject Test/Mock Controller**: Use `Get.put<TController>(mockController)` before pumping the widget.
3. **Clean Up GetX State**: Always call `Get.reset()` in `tearDown()` to avoid state leakage across test cases.

## Screen Widget Test Pattern
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:base_flutter_ai/core/widgets/app_error_view.dart';
import 'package:base_flutter_ai/core/widgets/app_loading_indicator.dart';
import 'package:base_flutter_ai/features/home/presentation/controllers/home_controller.dart';
import 'package:base_flutter_ai/features/home/presentation/views/home_view.dart';

void main() {
  tearDown(() {
    Get.reset();
  });

  testWidgets('renders loading state when controller isLoading is true', (tester) async {
    // Setup mock or test controller
    // Pump HomeView wrapped in GetMaterialApp
    // expect(find.byType(AppLoadingIndicator), findsOneWidget);
  });
}
```

## Verification Checklist
- [ ] `Get.reset()` invoked in `tearDown`.
- [ ] Widget tested across loading, error, and content states.
- [ ] User interactions (tapping retry, submitting text) asserted.

