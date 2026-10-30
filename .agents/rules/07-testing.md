# Rule 07: Testing Standards

1. **Test Coverage Requirements**:
   - Every new `GetxController` must have unit tests covering: loading state, successful data retrieval, and error handling.
   - Every new `RepositoryImpl` must have unit tests verifying datasource integration and error mapping.
   - Core utility methods (e.g. `SafeParser`) must have unit tests covering all edge cases.
   - Major screens must have widget tests verifying rendering across loading, error, empty, and populated states.
2. **Test Cleanliness**:
   - In widget tests, invoke `Get.reset()` in `tearDown()` to reset the GetX dependency container.
   - Mock external dependencies using `Mockito` or test doubles.
3. **Execution Gate**:
   - `flutter test` must pass with 100% green tests before any PR or merge.
   - Never use `@Skip` or disable tests without documenting an explicit blocking issue.

