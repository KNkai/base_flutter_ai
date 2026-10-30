---
name: flutter-debugging
description: "Systematic investigation, root-cause diagnosis, and resolution of Flutter runtime errors, build issues, layout overflows, and state synchronization bugs. Activate when diagnosing exceptions, broken builds, or unexpected behavior."
---

# Flutter Debugging & Root Cause Analysis

This skill provides a structured diagnostic methodology for identifying and fixing Flutter defects.

## When to Activate
- An exception or crash occurs in logs or during execution.
- `RenderFlex overflowed by X pixels` layout bugs.
- `LateInitializationError` or `GetX` controller lifecycle errors.
- Compilation or code generation failures.

## 4-Step Diagnostic Procedure

### 1. Identify the Exact Failure Point
- Inspect the stack trace from `AppLogger` or Flutter error output.
- Identify the first non-framework line in `lib/`.
- Inspect whether the failure occurred during:
  - Application startup (`bootstrapApp`, `StorageService.init`).
  - Network request or serialization (`DioClient`, `PostModel.fromJson`).
  - Widget build or layout phase (`build()`, `LayoutBuilder`).

### 2. Isolate the Root Cause
- **Type Cast Crash (`type 'String' is not a subtype of type 'num'`)**:
  - Solution: Use `SafeParser.toDouble()` or `SafeParser.toInt()`.
- **Controller Not Found (`"Controller" not found. You need to call "Get.put()"`))**:
  - Solution: Verify that the route was registered with its `Binding` in `AppPages`, or verify that `Get.toNamed()` was used instead of `Navigator.push()`.
- **RenderFlex Overflow**:
  - Solution: Wrap overflowing children in `Expanded`, `Flexible`, or replace `Column` with `ListView` / `SingleChildScrollView`.
- **Unbounded Height in ScrollView**:
  - Solution: Add `shrinkWrap: true` and `physics: const NeverScrollableScrollPhysics()` to nested list views, or convert to slivers.

### 3. Apply Minimal Surgical Fix
- Fix the defect at the root layer (e.g. data parsing in data layer rather than patching presentation layer).
- Maintain backward compatibility and avoid breaking API contracts.

### 4. Verify Resolution
- Run unit/widget tests covering the failing scenario.
- Run `flutter analyze` to ensure no lint regressions.

## Verification Checklist
- [ ] Root cause identified and documented.
- [ ] Regression test added to test suite.
- [ ] Zero warnings reported by analyzer.

