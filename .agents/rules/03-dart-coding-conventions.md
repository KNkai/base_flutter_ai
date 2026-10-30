# Rule 03: Dart Coding Conventions

1. **Formatting & Style**:
   - Always run `dart format .` before submitting code changes.
   - Adhere to `analysis_options.yaml` (strict casts, strict inference, strict raw types).
   - Use single quotes for string literals unless escaping double quotes.
2. **Type Safety & Immutability**:
   - Explicitly declare return types for all public functions, methods, and getters.
   - Use `final` for immutable variables and fields.
   - Use `const` constructors on widgets and models whenever possible to minimize widget rebuild cost.
3. **Control Flow**:
   - Use Dart 3 pattern matching, switch expressions, and records idiomatically.
   - Avoid empty `catch` blocks without error handling or logging.
4. **Logging**:
   - Do not use raw `print()`. Use `AppLogger.d()`, `AppLogger.i()`, `AppLogger.w()`, or `AppLogger.e()`.

