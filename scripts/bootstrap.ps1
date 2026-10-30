<#
.SYNOPSIS
    Bootstrap and configure the Flutter + AI Starter Kit for a new project.
.DESCRIPTION
    Checks prerequisite SDKs, comprehensively renames project identifiers (Dart packages,
    imports, Android applicationId/namespace/label, iOS bundle ID/display name, Web title,
    Windows project), resets Git origin, installs dependencies, runs code generation, and validates.
.PARAMETER ProjectName
    New package name for pubspec.yaml (snake_case, e.g. my_flutter_app).
.PARAMETER AppTitle
    Human-readable application title (e.g. "My Flutter App").
.PARAMETER Org
    Organization reverse domain for bundle identifiers (e.g. com.example).
.PARAMETER ResetGit
    Switch to disconnect from the base starter kit Git remote and initialize a fresh Git repository.
.PARAMETER SkipCodeGen
    Skip running build_runner code generation.
.EXAMPLE
    .\scripts\bootstrap.ps1 -ProjectName "my_awesome_app" -AppTitle "My Awesome App" -Org "com.mycompany" -ResetGit
#>
[CmdletBinding()]
param(
    [string]$ProjectName,
    [string]$AppTitle,
    [string]$Org,
    [switch]$ResetGit,
    [switch]$SkipCodeGen
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "`n=== $Message ===" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-WarningMsg {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Failure {
    param([string]$Message)
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

$RootDir = Split-Path -Parent $PSScriptRoot
Set-Location $RootDir

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Flutter + AI Engineering Starter Kit - Project Bootstrapper" -ForegroundColor Cyan
Write-Host " Workspace: $RootDir" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. SDK and Environment Checks
Write-Step "Checking Prerequisites"

try {
    $flutterCmd = Get-Command flutter -ErrorAction Stop
    $flutterVersion = flutter --version | Select-Object -First 1
    Write-Success "Flutter is installed: $flutterVersion"
} catch {
    Write-Failure "Flutter SDK was not found on your PATH. Please install Flutter stable."
    exit 1
}

try {
    $dartCmd = Get-Command dart -ErrorAction Stop
    $dartVersion = dart --version
    Write-Success "Dart SDK is installed: $dartVersion"
} catch {
    Write-Failure "Dart SDK was not found on your PATH."
    exit 1
}

try {
    $gitCmd = Get-Command git -ErrorAction Stop
    Write-Success "Git is installed."
} catch {
    Write-WarningMsg "Git is not detected on PATH. Version control features might be unavailable."
}

# 2. Comprehensive Identifier Renaming
if ($ProjectName -or $AppTitle -or $Org) {
    Write-Step "Updating Project Identifiers Across All Platforms"
    $PubspecPath = Join-Path $RootDir "pubspec.yaml"
    $oldName = "base_flutter_ai"

    if (Test-Path $PubspecPath) {
        $content = Get-Content $PubspecPath -Raw
        if ($content -match "name:\s*([a-zA-Z0-9_]+)") {
            $oldName = $matches[1]
        }
    }

    $targetName = if ($ProjectName) { $ProjectName } else { $oldName }
    $targetTitle = if ($AppTitle) { $AppTitle } else { $targetName }
    $targetOrg = if ($Org) { $Org.TrimEnd('.') } else { "com.example" }
    $targetBundleId = "$targetOrg.$targetName"

    # A. Dart & pubspec.yaml
    if ($ProjectName) {
        Write-Host "Renaming Dart package: '$oldName' -> '$targetName'..." -ForegroundColor Gray
        if (Test-Path $PubspecPath) {
            $pubContent = Get-Content $PubspecPath -Raw
            $pubContent = $pubContent -replace "name:\s*$oldName", "name: $targetName"
            Set-Content -Path $PubspecPath -Value $pubContent -NoNewline
            Write-Success "Updated package name in pubspec.yaml"
        }

        # Replace imports across lib/ and test/
        Write-Host "Updating Dart import statements across lib/ and test/..." -ForegroundColor Gray
        $dartFiles = Get-ChildItem -Path (Join-Path $RootDir "lib"), (Join-Path $RootDir "test") -Filter "*.dart" -Recurse
        foreach ($file in $dartFiles) {
            $fileContent = Get-Content $file.FullName -Raw
            if ($fileContent -match "package:$oldName/") {
                $updated = $fileContent -replace "package:$oldName/", "package:$targetName/"
                Set-Content -Path $file.FullName -Value $updated -NoNewline
            }
        }
        Write-Success "Updated package imports in Dart files"
    }

    # B. App Titles in Dart Entrypoints
    if ($AppTitle) {
        Write-Host "Updating application titles in Dart entrypoints..." -ForegroundColor Gray
        $mainFiles = Get-ChildItem -Path (Join-Path $RootDir "lib") -Filter "main*.dart"
        foreach ($file in $mainFiles) {
            $content = Get-Content $file.FullName -Raw
            $updated = $content -replace "appTitle:\s*'[^']+'", "appTitle: '$targetTitle'"
            Set-Content -Path $file.FullName -Value $updated -NoNewline
        }
        Write-Success "Updated appTitle in main entrypoints"
    }

    # C. Android Identifiers
    $androidGradle = Join-Path $RootDir "android\app\build.gradle.kts"
    if (Test-Path $androidGradle) {
        Write-Host "Updating Android namespace and applicationId..." -ForegroundColor Gray
        $content = Get-Content $androidGradle -Raw
        $content = $content -replace 'namespace\s*=\s*"[^"]+"', "namespace = `"$targetBundleId`""
        $content = $content -replace 'applicationId\s*=\s*"[^"]+"', "applicationId = `"$targetBundleId`""
        Set-Content -Path $androidGradle -Value $content -NoNewline
        Write-Success "Updated Android namespace and applicationId ($targetBundleId)"
    }

    $androidManifest = Join-Path $RootDir "android\app\src\main\AndroidManifest.xml"
    if (Test-Path $androidManifest) {
        Write-Host "Updating Android app label..." -ForegroundColor Gray
        $content = Get-Content $androidManifest -Raw
        $content = $content -replace 'android:label="[^"]+"', "android:label=`"$targetTitle`""
        Set-Content -Path $androidManifest -Value $content -NoNewline
        Write-Success "Updated Android app label ($targetTitle)"
    }

    # D. iOS Identifiers
    $iosPlist = Join-Path $RootDir "ios\Runner\Info.plist"
    if (Test-Path $iosPlist) {
        Write-Host "Updating iOS display name and bundle name..." -ForegroundColor Gray
        $content = Get-Content $iosPlist -Raw
        $content = $content -replace '(?s)<key>CFBundleDisplayName</key>\s*<string>[^<]*</string>', "<key>CFBundleDisplayName</key>`n`t<string>$targetTitle</string>"
        $content = $content -replace '(?s)<key>CFBundleName</key>\s*<string>[^<]*</string>', "<key>CFBundleName</key>`n`t<string>$targetName</string>"
        Set-Content -Path $iosPlist -Value $content -NoNewline
        Write-Success "Updated iOS CFBundleDisplayName and CFBundleName"
    }

    $iosPbxproj = Join-Path $RootDir "ios\Runner.xcodeproj\project.pbxproj"
    if (Test-Path $iosPbxproj) {
        Write-Host "Updating iOS PRODUCT_BUNDLE_IDENTIFIER..." -ForegroundColor Gray
        $content = Get-Content $iosPbxproj -Raw
        # Replace baseFlutterAi with target identifier
        $content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = [^;]+;', "PRODUCT_BUNDLE_IDENTIFIER = $targetBundleId;"
        $content = $content -replace "PRODUCT_BUNDLE_IDENTIFIER = $targetBundleId\.RunnerTests;", "PRODUCT_BUNDLE_IDENTIFIER = $targetBundleId.RunnerTests;"
        Set-Content -Path $iosPbxproj -Value $content -NoNewline
        Write-Success "Updated iOS bundle identifier ($targetBundleId)"
    }

    # E. Web Identifiers
    $webIndex = Join-Path $RootDir "web\index.html"
    if (Test-Path $webIndex) {
        Write-Host "Updating Web app title..." -ForegroundColor Gray
        $content = Get-Content $webIndex -Raw
        $content = $content -replace '<title>[^<]*</title>', "<title>$targetTitle</title>"
        $content = $content -replace '<meta name="apple-mobile-web-app-title" content="[^"]*">', "<meta name=`"apple-mobile-web-app-title`" content=`"$targetTitle`">"
        Set-Content -Path $webIndex -Value $content -NoNewline
        Write-Success "Updated Web title ($targetTitle)"
    }

    $webManifest = Join-Path $RootDir "web\manifest.json"
    if (Test-Path $webManifest) {
        $content = Get-Content $webManifest -Raw
        $content = $content -replace '"name":\s*"[^"]*"', "`"name`": `"$targetTitle`""
        $content = $content -replace '"short_name":\s*"[^"]*"', "`"short_name`": `"$targetTitle`""
        Set-Content -Path $webManifest -Value $content -NoNewline
        Write-Success "Updated Web manifest.json"
    }

    # F. Windows Identifiers
    $windowsCMake = Join-Path $RootDir "windows\CMakeLists.txt"
    if (Test-Path $windowsCMake) {
        $content = Get-Content $windowsCMake -Raw
        $content = $content -replace 'project\([a-zA-Z0-9_]+', "project($targetName"
        $content = $content -replace 'set\(BINARY_NAME\s*"[^"]*"\)', "set(BINARY_NAME `"$targetName`")"
        Set-Content -Path $windowsCMake -Value $content -NoNewline
        Write-Success "Updated Windows CMakeLists.txt"
    }

    $windowsRc = Join-Path $RootDir "windows\runner\Runner.rc"
    if (Test-Path $windowsRc) {
        $content = Get-Content $windowsRc -Raw
        $content = $content -replace 'VALUE "FileDescription", "[^"]*"', "VALUE `"FileDescription`", `"$targetTitle`""
        $content = $content -replace 'VALUE "InternalName", "[^"]*"', "VALUE `"InternalName`", `"$targetName`""
        $content = $content -replace 'VALUE "OriginalFilename", "[^"]*"', "VALUE `"OriginalFilename`", `"$targetName.exe`""
        $content = $content -replace 'VALUE "ProductName", "[^"]*"', "VALUE `"ProductName`", `"$targetTitle`""
        Set-Content -Path $windowsRc -Value $content -NoNewline
        Write-Success "Updated Windows Runner.rc"
    }
}

# 3. Disconnect from Base Starter Kit Git (Optional)
if ($ResetGit) {
    Write-Step "Resetting Git Version Control"
    try {
        $gitDir = Join-Path $RootDir ".git"
        if (Test-Path $gitDir) {
            Remove-Item -Path $gitDir -Recurse -Force
            git init
            git add .
            git commit -m "chore: initial commit from base_flutter_ai template"
            Write-Success "Initialized fresh, clean Git repository."
        }
    } catch {
        Write-WarningMsg "Could not reset Git repository: $_"
    }
}

# 4. Install Dependencies
Write-Step "Installing Dependencies"
try {
    flutter pub get
    Write-Success "flutter pub get completed successfully."
} catch {
    Write-Failure "Failed to resolve dependencies."
    exit 1
}

# 5. Code Generation
if (-not $SkipCodeGen) {
    Write-Step "Running Code Generation (build_runner)"
    try {
        dart run build_runner build --delete-conflicting-outputs
        Write-Success "Code generation completed successfully."
    } catch {
        Write-WarningMsg "Code generation had warnings. Check model annotations."
    }
} else {
    Write-Host "Skipping code generation as requested." -ForegroundColor Gray
}

# 6. MCP Verification
Write-Step "Verifying MCP Server Configuration"
$mcpConfigPath = Join-Path $RootDir ".agents\mcp_config.json"
if (Test-Path $mcpConfigPath) {
    Write-Success "MCP configuration verified at .agents\mcp_config.json"
} else {
    Write-WarningMsg "MCP config not found at .agents\mcp_config.json"
}

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " Starter Kit Bootstrap Completed Successfully!" -ForegroundColor Green
Write-Host " Project:   $ProjectName" -ForegroundColor Cyan
Write-Host " App Title: $AppTitle" -ForegroundColor Cyan
Write-Host " Bundle ID: $Org.$ProjectName" -ForegroundColor Cyan
Write-Host " Next steps:" -ForegroundColor Gray
Write-Host "   1. Run .\scripts\validate.ps1 to verify project health." -ForegroundColor Gray
Write-Host "   2. Run 'flutter run -t lib/main_dev.dart' to launch the app." -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Green
