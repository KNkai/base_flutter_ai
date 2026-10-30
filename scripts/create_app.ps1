<#
.SYNOPSIS
    One-Command Project Creator for Flutter + AI Starter Kit.
.DESCRIPTION
    Clones base_flutter_ai from GitHub into a new directory, renames all project identifiers
    (Dart packages, imports, Android applicationId, iOS bundle ID, Web/Windows titles), resets
    Git version control, installs dependencies, runs build_runner, and verifies project health.
.PARAMETER ProjectName
    Name of the new project (snake_case, e.g. "food_delivery").
.PARAMETER AppTitle
    Display name of the application (e.g. "Food Delivery App").
.PARAMETER Org
    Organization reverse domain for bundle identifiers (e.g. "com.company").
.PARAMETER OutputDir
    Destination directory path. Defaults to a new folder named after ProjectName in current location.
.PARAMETER RepoUrl
    Git repository URL of the base starter kit.
.EXAMPLE
    .\scripts\create_app.ps1 -ProjectName "food_app" -AppTitle "Food Delivery" -Org "com.mycompany"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ProjectName,

    [Parameter(Position = 1)]
    [string]$AppTitle,

    [Parameter(Position = 2)]
    [string]$Org = "com.example",

    [Parameter(Position = 3)]
    [string]$OutputDir,

    [string]$RepoUrl = "https://github.com/KNkai/base_flutter_ai.git"
)

$ErrorActionPreference = "Stop"

if (-not $AppTitle) {
    # Convert snake_case or kebab-case to Title Case
    $AppTitle = (Get-Culture).TextInfo.ToTitleCase($ProjectName.Replace('_', ' ').Replace('-', ' '))
}

if (-not $OutputDir) {
    $OutputDir = Join-Path (Get-Location) $ProjectName
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Flutter + AI One-Command Project Creator" -ForegroundColor Cyan
Write-Host " Project Name: $ProjectName" -ForegroundColor Yellow
Write-Host " App Title:    $AppTitle" -ForegroundColor Yellow
Write-Host " Bundle ID:    $Org.$ProjectName" -ForegroundColor Yellow
Write-Host " Target Path:  $OutputDir" -ForegroundColor Yellow
Write-Host " Source Repo:  $RepoUrl" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan

if (Test-Path $OutputDir) {
    Write-Error "Target directory already exists: $OutputDir. Please specify a non-existent path or delete it first."
    exit 1
}

# 1. Clone repository
Write-Host "`n[1/4] Cloning base starter kit from GitHub..." -ForegroundColor Cyan
git clone $RepoUrl $OutputDir
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to clone repository from $RepoUrl."
    exit 1
}

# 2. Run Bootstrap Script
Write-Host "`n[2/4] Configuring project identifiers and dependencies..." -ForegroundColor Cyan
$bootstrapScript = Join-Path $OutputDir "scripts\bootstrap.ps1"

Push-Location $OutputDir
try {
    & powershell -ExecutionPolicy Bypass -File $bootstrapScript `
        -ProjectName $ProjectName `
        -AppTitle $AppTitle `
        -Org $Org `
        -ResetGit

    # 3. Run Validation
    Write-Host "`n[3/4] Running automated QA verification..." -ForegroundColor Cyan
    $validateScript = Join-Path $OutputDir "scripts\validate.ps1"
    & powershell -ExecutionPolicy Bypass -File $validateScript
} finally {
    Pop-Location
}

# 4. Completion
Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " SUCCESS! Your new Flutter project is ready to go!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Location: $OutputDir`n" -ForegroundColor Cyan
Write-Host "To start developing:" -ForegroundColor Yellow
Write-Host "  cd `"$OutputDir`"" -ForegroundColor White
Write-Host "  flutter run -t lib/main_dev.dart`n" -ForegroundColor White
Write-Host "To open in your editor:" -ForegroundColor Yellow
Write-Host "  code `"$OutputDir`"`n" -ForegroundColor White

