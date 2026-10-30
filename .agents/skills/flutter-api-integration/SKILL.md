---
name: flutter-api-integration
description: "Process for integrating RESTful APIs into Flutter features using Dio, remote data sources, repositories, and error mappers. Activate when consuming backend endpoints, adding API requests, or connecting features to web services."
---

# Flutter API Integration Workflow

This skill standardizes how backend endpoints are integrated into application features.

## When to Activate
- Connecting a new feature to REST APIs.
- Adding GET, POST, PUT, DELETE operations to datasources.
- Transforming backend JSON payloads into strongly-typed domain models.

## Required Context Inspection
1. Inspect `lib/core/constants/api_endpoints.dart` to check existing paths.
2. Inspect `lib/core/network/dio_client.dart` and `lib/core/errors/error_handler.dart`.

## Integration Flow

```
[REST API] <--- DioClient <--- RemoteDataSource <--- RepositoryImpl <--- Controller
```

### 1. Register Endpoint Constant
In `lib/core/constants/api_endpoints.dart`:
```dart
static const String userProfile = '/user/profile';
```

### 2. Implement Remote DataSource
In `lib/features/<feature>/data/datasources/<feature>_remote_datasource.dart`:
```dart
abstract class UserRemoteDataSource {
  Future<UserModel> fetchProfile();
  Future<void> updateProfile(Map<String, dynamic> body);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _client;

  UserRemoteDataSourceImpl(this._client);

  @override
  Future<UserModel> fetchProfile() async {
    final response = await _client.get<Map<String, dynamic>>(ApiEndpoints.userProfile);
    return UserModel.fromJson(response.data!);
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> body) async {
    await _client.put<dynamic>(ApiEndpoints.userProfile, data: body);
  }
}
```

### 3. Implement Repository Implementation
In `lib/features/<feature>/data/repositories/<feature>_repository_impl.dart`:
```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> getProfile() async {
    try {
      final model = await _remoteDataSource.fetchProfile();
      return model.toEntity();
    } catch (e, st) {
      throw ErrorHandler.handle(e, st);
    }
  }
}
```

## Common Mistakes
- Calling `_client.get` without catching or mapping exceptions.
- Forgetting to convert model to entity (`toEntity()`).
- Hardcoding query strings directly in URL rather than using `queryParameters: {}`.

## Verification Checklist
- [ ] Endpoint declared in `ApiEndpoints`.
- [ ] Safe JSON parsing applied in model.
- [ ] Exceptions mapped via `ErrorHandler.handle`.
- [ ] Unit test written with mocked datasource.

