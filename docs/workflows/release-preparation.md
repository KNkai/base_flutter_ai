# Workflow: Release Preparation

## 1. Overview
Governs preparation, versioning, signing checks, flavor building, and bundle generation for publishing production Flutter releases.

## 2. Inputs
- Release version bump type (Major, Minor, or Patch).
- Target platform(s): Android (AAB), iOS (IPA), Web, Windows.
- Changelog notes.

## 3. Preconditions
- All feature PRs merged and `validate.ps1` passing on `main` branch.
- Platform signing credentials (keystores, provisioning profiles) configured in local build environments.

## 4. Required Agents & Skills
- **Lead Agent**: `flutter-architect`
- **Supporting Agent**: `flutter-tester`
- **Relevant Skills**: `flutter-release-management`, `flutter-security-review`

## 5. Execution Steps

### Step 1: Pre-Release Quality Audit
Run full validation suite:
```powershell
.\scripts\validate.ps1
```

### Step 2: Version Bump in `pubspec.yaml`
Update `version`:
```yaml
version: 1.1.0+2
```

### Step 3: Run Platform Release Builds
- **Android App Bundle**:
  ```powershell
  flutter build appbundle --target lib/main_prod.dart --release
  ```
- **iOS Archive**:
  ```powershell
  flutter build ipa --target lib/main_prod.dart --release
  ```
- **Web Build**:
  ```powershell
  flutter build web --target lib/main_prod.dart --release
  ```
- **Windows Executable**:
  ```powershell
  flutter build windows --target lib/main_prod.dart --release
  ```

### Step 4: Smoke Test Release Artifacts
- Install release build on physical test devices.
- Verify environment target is Production (correct base URL, debug banner hidden, console logging disabled).

## 6. Acceptance Criteria
- [ ] Release builds succeed without compiler errors or shrinker failures.
- [ ] Production flavor points to live endpoints with logging disabled.
- [ ] Git tag created matching release version (e.g., `v1.1.0`).

## 7. Expected Outputs
- Signed release binaries ready for store deployment.
- Updated `CHANGELOG.md` and Git release tag.

