---
name: flutter-integration-testing
description: "Designing and executing end-to-end integration tests using integration_test package. Activate when verifying full application user journeys across real devices, emulators, or web browsers."
---

# Flutter Integration Testing Guide

This skill governs end-to-end integration testing for full application journeys.

## When to Activate
- Testing full user flows from app launch to checkout or dashboard navigation.
- Verifying cross-layer integration between storage, network, controllers, and screens.
- Running CI/CD automated smoke tests on real platforms.

## Directory Structure
```
integration_test/
└── app_test.dart
```

## Integration Test Skeleton
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:base_flutter_ai/core/config/app_config.dart';
import 'package:base_flutter_ai/core/config/env_config.dart';
import 'package:base_flutter_ai/main_common.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launch and home navigation flow', (WidgetTester tester) async {
    await bootstrapApp(
      const EnvConfig(
        environment: Environment.dev,
        appTitle: 'Integration Test App',
        apiBaseUrl: 'https://jsonplaceholder.typicode.com',
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Starter Kit Dashboard'), findsOneWidget);
  });
}
```

## Running Integration Tests
```powershell
flutter test integration_test/app_test.dart
```

## Verification Checklist
- [ ] Uses real application entrypoint logic (`bootstrapApp`).
- [ ] Waits for animations and network requests with `pumpAndSettle`.
- [ ] Verifies critical path user flows without flake.

