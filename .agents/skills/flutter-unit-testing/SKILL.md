---
name: flutter-unit-testing
description: "Authoring isolated unit tests for GetxControllers, repositories, datasources, and utility functions using package:test and Mockito. Activate when writing unit tests, testing business logic, or generating test mocks."
---

# Flutter Unit Testing Guide

This skill standardizes unit testing practices for controllers, repositories, and utilities.

## When to Activate
- Writing tests for a new `GetxController`.
- Writing tests for a repository or datasource with mocked network responses.
- Writing tests for utility classes (`SafeParser`, `Formatters`).

## Controller Unit Test Pattern
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:base_flutter_ai/features/home/domain/entities/post_entity.dart';
import 'package:base_flutter_ai/features/home/domain/repositories/post_repository.dart';
import 'package:base_flutter_ai/features/home/presentation/controllers/home_controller.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late HomeController controller;
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
    // Test controller without automatic fetch on init if preferred, or test fetchPosts directly
  });

  test('fetchPosts updates posts and sets loading to false on success', () async {
    final samplePosts = [
      const PostEntity(id: 1, userId: 1, title: 'Title', body: 'Body'),
    ];

    when(mockRepository.getPosts()).thenAnswer((_) async => samplePosts);

    controller = HomeController(postRepository: mockRepository);
    await controller.fetchPosts();

    expect(controller.posts.length, 1);
    expect(controller.isLoading, false);
    expect(controller.errorMessage, isNull);
  });
}
```

## Testing SafeParser
```dart
test('SafeParser.toDouble correctly parses mixed inputs', () {
  expect(SafeParser.toDouble(12.5), 12.5);
  expect(SafeParser.toDouble('12.5'), 12.5);
  expect(SafeParser.toDouble(null, 1.0), 1.0);
  expect(SafeParser.toDouble('invalid', 0.0), 0.0);
});
```

## Running Unit Tests
```powershell
flutter test test/features/
```

## Verification Checklist
- [ ] Unit tests execute fast with no reliance on physical devices or network.
- [ ] Edge cases (empty results, errors, timeouts) covered.
- [ ] Tests pass cleanly with `flutter test`.

