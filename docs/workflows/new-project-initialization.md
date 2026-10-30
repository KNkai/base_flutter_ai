# Workflow: New Project Initialization

## 1. Overview
This workflow defines the standard process for creating and configuring a new application from this starter kit template in **a single command**.

## 2. Fast 1-Command Initialization (Recommended)

From **any folder** on your machine, run this single PowerShell command:

```powershell
.\scripts\create_app.ps1 -ProjectName "food_delivery" -AppTitle "Food Delivery App" -Org "com.mycompany"
```

Or clone and bootstrap in one line:

```powershell
git clone https://github.com/KNkai/base_flutter_ai.git food_delivery; cd food_delivery; .\scripts\bootstrap.ps1 -ProjectName "food_delivery" -AppTitle "Food Delivery App" -Org "com.mycompany" -ResetGit
```

### What This Single Command Does Automatically:
1. **Clones** the base starter kit repo from GitHub.
2. **Renames package** in `pubspec.yaml` to your new project name.
3. **Replaces imports** (`package:base_flutter_ai/` -> `package:<new_project_name>/`) across all `lib/` and `test/` Dart files.
4. **Renames Android**:
   - `namespace` and `applicationId` in `android/app/build.gradle.kts` -> `<Org>.<new_project_name>`.
   - App label in `android/app/src/main/AndroidManifest.xml` -> `<AppTitle>`.
5. **Renames iOS**:
   - `CFBundleDisplayName` and `CFBundleName` in `ios/Runner/Info.plist`.
   - `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj`.
6. **Renames Web & Windows**:
   - Page `<title>` and `meta` in `web/index.html`.
   - `name` and `short_name` in `web/manifest.json`.
   - `project()` and `BINARY_NAME` in `windows/CMakeLists.txt` and `Runner.rc`.
7. **Resets Git**:
   - Detaches from the base starter kit remote and initializes a clean, fresh Git repository for your own project.
8. **Installs Dependencies & Generates Code**:
   - Runs `flutter pub get`.
   - Runs `dart run build_runner build`.
9. **Validates Health**:
   - Runs `validate.ps1` (format check, `flutter analyze`, `flutter test`).

## 3. Permanent Global Shortcut (Optional)
If you want to type `nfa` (New Flutter App) anywhere on your Windows PC:

Add this function to your PowerShell profile (`notepad $PROFILE`):
```powershell
function New-FlutterApp {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [string]$Title = $Name,
        [string]$Org = "com.example"
    )
    $repo = "https://github.com/KNkai/base_flutter_ai.git"
    git clone $repo $Name
    Set-Location $Name
    powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap.ps1 -ProjectName $Name -AppTitle $Title -Org $Org -ResetGit
}
Set-Alias nfa New-FlutterApp
```
Then from any directory, you just type:
```powershell
nfa food_delivery "Food Delivery App" com.mycompany
```

## 4. Acceptance Criteria
- [ ] Project compiles with zero warnings under `flutter analyze`.
- [ ] All unit and widget tests pass with `flutter test`.
- [ ] App launches into development mode with `flutter run -t lib/main_dev.dart`.
