---
name: flutter-performance-optimization
description: "Techniques for optimizing Flutter rendering performance, widget rebuild scope, memory usage, and network payload efficiency. Activate when profiling apps, reducing jank, or fixing memory leaks."
---

# Flutter Performance Optimization Guide

This skill provides guidelines and patterns for maintaining 60/120 FPS rendering and low memory footprints.

## When to Activate
- Detecting UI stutter, jank, or dropped frames during animations/scrolling.
- Investigating memory spikes or retained controllers.
- Profiling Flutter apps using DevTools.

## Key Optimization Rules

### 1. Granular Reactive Scoping
- Never wrap a root `Scaffold` or large container in `Obx(() => ...)`.
- Wrap **only** the precise widget or leaf node that depends on the reactive observable:
```dart
// BAD: Rebuilds whole page on counter change
Obx(() => Scaffold(
  appBar: AppBar(title: Text('Counter')),
  body: Center(child: Text('${controller.count}')),
))

// GOOD: Only rebuilds Text
Scaffold(
  appBar: AppBar(title: const Text('Counter')),
  body: Center(
    child: Obx(() => Text('${controller.count}')),
  ),
)
```

### 2. Constructor `const` Discipline
- Use `const` widgets across static elements. Flutter bypasses subtree rebuilds when a widget is identical and const.

### 3. Controller Lifecycle & Disposal
- Register controllers via `Get.lazyPut()` in route `Bindings`.
- Do not use `permanent: true` or `fenix: true` unless the service represents a true application-wide daemon.
- Always clean up `StreamSubscription`, `TextEditingController`, and `ScrollController` in `onClose()`.

### 4. Image & Asset Optimization
- Use cached network images with memory caches and disk caches for remote thumbnails.
- Specify `cacheWidth` and `cacheHeight` when rendering downscaled images.

## Verification Checklist
- [ ] No full-screen `Obx` wrappers.
- [ ] All controllers disposed upon route pop.
- [ ] All streams and subscriptions closed in `onClose()`.
- [ ] DevTools CPU profiler shows 0 red frame spikes during scrolling.

