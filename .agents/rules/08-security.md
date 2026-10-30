# Rule 08: Security & Secret Management

1. **Token & Credential Storage**:
   - Authentication tokens (JWTs, refresh tokens, access credentials) must ALWAYS be stored in `SecureStorageService` (`flutter_secure_storage`).
   - Never store tokens in `SharedPreferences`, log files, or plaintext files.
2. **Secrets & Keys**:
   - Never hardcode API secrets, private keys, or credentials in Dart source code.
   - Use environment variables or secure build-time injection.
3. **Network Security**:
   - Enforce HTTPS for all external communication.
   - Never bypass SSL validation in production builds.
4. **Data Privacy**:
   - Do not print sensitive user data (passwords, payment details, PII) in logs or analytics payloads.

