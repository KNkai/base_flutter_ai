---
name: flutter-security-review
description: "Auditing Flutter applications for security vulnerabilities, secret leakage, insecure storage, SSL misconfigurations, and data handling risks. Activate when conducting security audits or preparing for compliance reviews."
---

# Flutter Security Review Guide

This skill governs security verification and vulnerability prevention in Flutter apps.

## When to Activate
- Prior to production releases.
- When reviewing authentication, token storage, and API headers.
- Auditing dependencies for reported CVEs.

## Security Audit Checklist

### 1. Storage of Secrets & Credentials
- [ ] **NO plaintext tokens**: Sensitive tokens (JWTs, refresh tokens, PINs) MUST be stored in `SecureStorageService` (`flutter_secure_storage`).
- [ ] **NO secrets in source control**: Never commit API keys, production certificates, or encryption keys in Git.

### 2. Transport Layer Security (TLS/HTTPS)
- [ ] Enforce `https://` for all production endpoints.
- [ ] Do not disable `badCertificateCallback` in production builds.

### 3. Deep Link Security
- [ ] Validate and sanitize all parameters extracted from incoming deep links before routing or fetching resources.

### 4. Logging & Diagnostics
- [ ] Disable verbose network logging in production builds (`enableLogging: false` in `EnvConfig`).
- [ ] Ensure `AppLogger` does not output passwords, PII, or access tokens to console output.

## Verification Checklist
- [ ] `git diff` shows no sensitive strings or credentials.
- [ ] `SecureStorageService` utilized for auth tokens.
- [ ] Production environment config disables logging.

