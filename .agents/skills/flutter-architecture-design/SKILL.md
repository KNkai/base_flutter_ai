---
name: flutter-architecture-design
description: "Architectural design, system boundary definition, and dependency structuring for Flutter enterprise applications using Clean Architecture and GetX. Activate when planning modules, structuring packages, or refactoring codebase architecture."
---

# Flutter Architecture Design Workflow

This skill outlines the architectural rules, structural principles, and module boundaries governing this Flutter starter kit.

## When to Activate
- The user asks for architectural design advice, refactoring recommendations, or project structural planning.
- Designing a multi-module or multi-package Flutter project.
- Evaluating architectural compliance and boundaries.

## Required Context Inspection
1. Read `AGENTS.md` to review the immutable technology stack and core principles.
2. Review `lib/core/` to understand existing shared utilities, configs, and error abstractions.
3. Review `lib/app/` to understand application-wide routing and theming.

## Architectural Layers & Separation of Concerns

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  - GetView<TController> Widgets                             │
│  - GetxController (Reactive Rx State, UI Logic, Error State)│
│  - Bindings (Get.lazyPut for Dependency Injection)          │
└──────────────────────────────┬──────────────────────────────┘
                               │ depends on
┌──────────────────────────────▼──────────────────────────────┐
│                      Domain Layer                           │
│  - Pure Dart Entities (Business Models)                     │
│  - Repository Interfaces (Contracts, e.g. PostRepository)   │
│  - Use Cases (Optional, for complex shared business logic)  │
└──────────────────────────────▲──────────────────────────────┘
                               │ implemented by
┌──────────────────────────────┴──────────────────────────────┐
│                       Data Layer                            │
│  - Data Models (fromJson, toJson, SafeParser, toEntity)     │
│  - Remote / Local Data Sources                              │
│  - Repository Implementations (Calls DS, maps to Failures)  │
└──────────────────────────────┬──────────────────────────────┘
                               │ depends on
┌──────────────────────────────▼──────────────────────────────┐
│                    Core Infrastructure                      │
│  - DioClient, Interceptors, AppConfig, ErrorHandler         │
│  - StorageService, SecureStorageService, SafeParser         │
└─────────────────────────────────────────────────────────────┘
```

## Layer Boundary Rules
1. **Presentation -> Domain**: Controllers invoke repository interfaces and consume pure domain entities.
2. **Data -> Domain**: Repository implementations in `data/` implement interfaces declared in `domain/`.
3. **Data -> Core**: Datasources use `DioClient` and storage services from `core/`.
4. **No Reverse Dependencies**: Domain must NEVER depend on Data, Presentation, or Flutter UI classes.

## Common Mistakes
- Importing `flutter/material.dart` or `get/get.dart` into `domain/entities/`.
- Accessing `Dio` or `SharedPreferences` from controllers.
- Exposing raw API responses (`Response<Map>`) into presentation views.

## Verification Checklist
- [ ] No `domain/` file imports packages other than pure Dart standard libraries or utilities.
- [ ] Cross-feature communication happens via repository contracts or shared services.
- [ ] Dependency injection is strictly configured via `Bindings`.

