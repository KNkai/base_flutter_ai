# Workflow: API Integration

## 1. Overview
Standardized procedure for connecting application features to backend REST APIs using Dio, secure interceptors, resilient serialization, and centralized error handling.

## 2. Inputs
- Backend OpenAPI / Swagger documentation or endpoint specifications.
- Sample JSON payloads for request bodies and success/error responses.
- Authentication requirements (public, Bearer JWT, refresh tokens).

## 3. Preconditions
- `DioClient` registered in `InitialBinding`.
- Base URLs configured in `EnvConfig`.

## 4. Required Agents & Skills
- **Lead Agent**: `flutter-api-engineer`
- **Supporting Agent**: `flutter-developer`
- **Relevant Skills**: `flutter-api-integration`, `flutter-dio-networking`, `flutter-json-model-generation`

## 5. Execution Steps

### Step 1: Register Endpoint Constants
Add endpoint path constants in `lib/core/constants/api_endpoints.dart`:
```dart
static const String userOrders = '/users/{id}/orders';
```

### Step 2: Create Data Model with SafeParser
Create model file with `@JsonSerializable()`:
- Use `SafeParser.toDouble` for floats/decimals.
- Use `SafeParser.toInt` for counters/IDs.
- Implement `toEntity()` and `fromEntity()`.
- Run `dart run build_runner build`.

### Step 3: Implement Remote DataSource
- Inject `DioClient` into DataSource.
- Use `client.get`, `client.post`, etc.
- Pass query arguments via `queryParameters: {}`.

### Step 4: Implement Repository with Centralized Error Handling
- Wrap datasource calls in try/catch.
- Delegate all errors to `ErrorHandler.handle(e, st)` and rethrow typed `Failure`.

### Step 5: Verify with Mockito Unit Tests
- Create unit tests with mocked `DioClient` or mocked datasource.
- Test 200 OK, 401 Unauthorized, 422 Validation error, and Network Timeout scenarios.

## 6. Acceptance Criteria
- [ ] No direct `Dio` calls in controllers or views.
- [ ] All network exceptions produce user-friendly `Failure` objects.
- [ ] Model survives malformed/stringified numeric JSON fields without casting crashes.

## 7. Expected Outputs
- Fully integrated remote datasource and repository.
- Unit tests verifying endpoint consumption.

