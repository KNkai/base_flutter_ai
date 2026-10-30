<#
.SYNOPSIS
    Automated Quality Assurance and Validation Script for Flutter + AI Starter Kit.
.DESCRIPTION
    Runs dart format check, flutter analyze, and flutter test suite.
.EXAMPLE
    .\scripts\validate.ps1
#>
[CmdletBinding()]
param(
    [switch]$FixFormat
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "`n=== $Message ===" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Failure {
    param([string]$Message)
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

$RootDir = Split-Path -Parent $PSScriptRoot
Set-Location $RootDir

$hasError = $false

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Flutter + AI Starter Kit - Automated Validation Suite" -ForegroundColor Cyan
Write-Host " Workspace: $RootDir" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Dart Format Check
Write-Step "1/3 Checking Code Formatting"
if ($FixFormat) {
    dart format .
    Write-Success "Formatting applied."
} else {
    $formatOutput = dart format --output=none --set-exit-if-changed . 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Code formatting is clean."
    } else {
        Write-Failure "Formatting issues detected! Run 'dart format .' or '.\scripts\validate.ps1 -FixFormat' to resolve."
        $formatOutput | Write-Host -ForegroundColor Yellow
        $hasError = $true
    }
}

# 2. Static Analysis
Write-Step "2/3 Running Static Code Analysis (flutter analyze)"
$analyzeOutput = flutter analyze --no-fatal-infos 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Success "Static analysis passed with 0 issues."
} else {
    Write-Failure "Static analysis found warnings or errors!"
    $analyzeOutput | Write-Host -ForegroundColor Red
    $hasError = $true
}

# 3. Test Suite (Unit & Widget Tests)
Write-Step "3/3 Running Automated Test Suite (flutter test)"
$testOutput = flutter test 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Success "All tests passed successfully."
} else {
    Write-Failure "One or more tests failed!"
    $testOutput | Write-Host -ForegroundColor Red
    $hasError = $true
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
if (-not $hasError) {
    Write-Host " ALL QUALITY CHECKS PASSED SUCCESSFULLY! Ready for commit/PR." -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host " VALIDATION FAILED! Please resolve the issues above." -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Cyan
    exit 1
}

