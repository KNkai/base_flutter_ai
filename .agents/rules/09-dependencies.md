# Rule 09: Dependency Management

1. **Approved Stack**:
   - State Management: `get`
   - Networking: `dio`
   - Storage: `shared_preferences`, `flutter_secure_storage`
   - Serialization: `json_annotation`, `json_serializable`
   - Testing: `flutter_test`, `mockito`
2. **Forbidden Alternatives**:
   - **Do NOT introduce**:
     - `flutter_bloc` / `bloc`
     - `flutter_riverpod` / `riverpod`
     - `provider`
     - `package:http`
     - `get_it` / `injectable`
3. **Evaluating New Packages**:
   - Vet dependencies for active maintenance, null safety, platform support (iOS, Android, Web, Desktop), and license compatibility (MIT/BSD/Apache-2.0).
   - Prefer standard Flutter / Dart official packages before introducing third-party wrappers.

