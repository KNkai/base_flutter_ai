# Workflow: Bug Investigation & Fixing

## 1. Overview
Standard operating procedure for investigating, reproducing, repairing, and preventing regressions for Flutter bugs.

## 2. Inputs
- Bug report, exception stack trace, or user symptom description.
- Reproduction steps or device/platform conditions.

## 3. Preconditions
- Access to project codebase and test suite.

## 4. Required Agents & Skills
- **Lead Agent**: `flutter-developer`
- **Supporting Agents**: `flutter-ui-engineer`, `flutter-tester`
- **Relevant Skills**: `flutter-debugging`, `flutter-unit-testing`, `flutter-widget-testing`

## 5. Execution Steps

### Step 1: Reproduce & Capture
1. Locate the failing code path via the stack trace.
2. Write a minimal failing test (unit or widget test) that reproduces the failure before modifying production code.

### Step 2: Determine Root Cause
- Check for common failure categories:
  - **Type casting crash**: Missing `SafeParser` on dynamic JSON value.
  - **GetX controller error**: Route opened without binding or controller disposed prematurely.
  - **Layout overflow**: Missing `Expanded`, `Flexible`, or unconstrained scroll view.
  - **Memory leak**: Undisposed `StreamSubscription` or `TextEditingController`.

### Step 3: Implement Minimal Surgical Fix
1. Apply the fix strictly at the layer responsible (data, domain, presentation).
2. Avoid invasive refactoring during a bug fix turn.

### Step 4: Verify Fix & Regression Prevention
1. Run the failing test written in Step 1 — verify that it now passes.
2. Run `.\scripts\validate.ps1` to ensure no collateral breaks.

## 6. Acceptance Criteria
- [ ] Bug is permanently resolved.
- [ ] Regression test added to test suite.
- [ ] No new lint warnings or broken existing tests.

## 7. Expected Outputs
- Surgical fix applied to affected file(s).
- New test case guarding against regression.

