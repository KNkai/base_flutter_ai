---
name: flutter-code-review
description: "Comprehensive code review procedure for auditing Flutter code changes against Clean Architecture, GetX standards, performance, security, and test coverage. Activate when conducting pull request audits or reviewing code quality."
---

# Flutter Code Review & Audit Workflow

This skill defines the verification checklist and review standards for changes made in this repository.

## When to Activate
- Reviewing a completed feature, bug fix, or refactor.
- Performing automated or manual PR audits.
- Checking compliance before merging into main branches.

## Review Dimensions

### 1. Architectural Integrity
- [ ] Are business logic and network requests completely separate from UI widgets?
- [ ] Do domain entities remain pure Dart classes (no JSON annotations, no Flutter imports)?
- [ ] Are dependencies injected via `Bindings` using `Get.lazyPut()`?
- [ ] Are all routes registered in `AppPages` with named constants?
- [ ] Are forbidden packages absent (`flutter_bloc`, `riverpod`, `package:http`)?

### 2. Error Handling & Parsing
- [ ] Are all API requests protected with `ErrorHandler.handle()`?
- [ ] Are numeric, boolean, or list fields parsed using `SafeParser`?
- [ ] Are UI loading, error, and empty states appropriately displayed?

### 3. Code Cleanliness & Style
- [ ] Did `dart format .` run with 0 format changes required?
- [ ] Does `flutter analyze` exit with 0 errors and 0 warnings?
- [ ] Are widget constructors marked `const` where possible?
- [ ] Are raw `print()` statements replaced with `AppLogger`?

### 4. Security & Storage
- [ ] Are auth tokens and secrets stored only in `SecureStorageService`?
- [ ] Are API keys absent from version control?

### 5. Automated Tests
- [ ] Are unit tests provided for new controllers and repositories?
- [ ] Are widget tests provided for primary UI flows?
- [ ] Do all tests in `flutter test` pass?

## Review Output Format
Provide feedback structured into:
1. **Critical Blockers** (must fix before merge)
2. **Architecture / Performance Recommendations**
3. **Nitpicks / Style Improvements**
4. **Final Approval Verdict**

