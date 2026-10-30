# Workflow: Code Review & Quality Audit

## 1. Overview
Procedure for auditing proposed changes, verifying architecture compliance, checking security, and guaranteeing test coverage before merging code.

## 2. Inputs
- Git branch diff, pull request, or list of modified files.
- Feature requirements or issue description.

## 3. Preconditions
- Branch pushed and rebased against the latest base branch.

## 4. Required Agents & Skills
- **Lead Agent**: `flutter-reviewer`
- **Supporting Agent**: `flutter-architect`
- **Relevant Skills**: `flutter-code-review`, `flutter-security-review`, `flutter-architecture-design`

## 5. Execution Steps

### Step 1: Run Automated Tooling Verification
Execute the local validation script:
```powershell
.\scripts\validate.ps1
```
Check:
- `dart format` output.
- `flutter analyze` report.
- `flutter test` execution.

### Step 2: Architecture & Cleanliness Audit
- Verify that business logic is strictly inside `GetxController`.
- Verify that domain entities are clean Dart objects.
- Ensure dependency injection uses `Get.lazyPut` in route bindings.
- Confirm forbidden libraries (Riverpod, Bloc, `package:http`) were not added.

### Step 3: Security & Storage Audit
- Confirm no API keys or plaintext tokens are committed.
- Confirm auth tokens are read/written exclusively via `SecureStorageService`.

### Step 4: Review Report Compilation
Structure feedback into:
1. Blockers (must fix).
2. Architecture / Performance suggestions.
3. Minor nits.
4. Approval status.

## 6. Acceptance Criteria
- [ ] Zero blocking architectural violations.
- [ ] 100% automated test pass rate.
- [ ] Zero static analysis warnings.

## 7. Expected Outputs
- Formal review summary report with actionable recommendations.

