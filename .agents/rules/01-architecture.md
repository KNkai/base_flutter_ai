# Rule 01: Architecture & Modularity

1. Follow **Feature-First Clean Architecture**:
   - `lib/app/`: Navigation, routes, themes, root bindings, and app entry.
   - `lib/core/`: Reusable shared infrastructure (zero business logic).
   - `lib/features/<name>/`: Self-contained feature slices (`data/`, `domain/`, `presentation/`).
2. **Domain Isolation**:
   - Entities in `domain/entities/` must be pure Dart classes.
   - Domain must NEVER import `flutter/material.dart`, `get/get.dart`, `dio/dio.dart`, or data layer classes.
3. **Data Layer Responsibilities**:
   - Models in `data/models/` handle JSON mapping (`fromJson`, `toJson`) and convert to entities (`toEntity()`).
   - Datasources consume `DioClient`.
   - Repositories implement domain contracts and wrap errors with `ErrorHandler.handle()`.
4. **Presentation Layer Responsibilities**:
   - Views must not contain API calls, data mutations, or storage logic.
   - Views delegate all interactions to `GetxController`.

