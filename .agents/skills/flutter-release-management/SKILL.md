---
name: flutter-release-management
description: "Release preparation, version bumping, flavor building, and deployment verification for Flutter applications. Activate when preparing release builds, creating APK/AAB/IPA packages, or tagging version releases."
---

# Flutter Release Management Guide

This skill governs the process of preparing and building production releases of the Flutter application.

## When to Activate
- Bumping application version or build number in `pubspec.yaml`.
- Generating production release bundles (Android App Bundle, iOS IPA, Web build, Desktop installer).
- Verifying release flavor configurations.

## Release Steps

### 1. Versioning
Follow Semantic Versioning (`MAJOR.MINOR.PATCH+BUILD`) in `pubspec.yaml`:
```yaml
version: 1.0.1+2
```

### 2. Flavor Build Commands
- **Android App Bundle (Production)**:
  ```powershell
  flutter build appbundle --target lib/main_prod.dart --release
  ```
- **Android APK (Staging)**:
  ```powershell
  flutter build apk --target lib/main_staging.dart --release
  ```
- **iOS Release**:
  ```powershell
  flutter build ipa --target lib/main_prod.dart --release
  ```
- **Web Release**:
  ```powershell
  flutter build web --target lib/main_prod.dart --release
  ```
- **Windows Release**:
  ```powershell
  flutter build windows --target lib/main_prod.dart --release
  ```

### 3. Pre-Release Verification
Always run the validation script before signing or publishing:
```powershell
.\scripts\validate.ps1
```

## Verification Checklist
- [ ] Version and build numbers updated in `pubspec.yaml`.
- [ ] Targeted entry point points to `lib/main_prod.dart`.
- [ ] All unit, widget, and integration tests passing.
- [ ] ProGuard / Obfuscation configured if required for release artifacts.

