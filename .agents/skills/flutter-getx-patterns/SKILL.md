---
name: flutter-getx-patterns
description: "Guidelines and best practices for GetX state management, dependency injection, and named routing in Flutter. Activate when implementing controllers, workers, reactive state, route bindings, or navigation."
---

# Flutter GetX Patterns & Best Practices

This skill provides idiomatic conventions for using GetX in production Flutter applications without suffering from memory leaks, anti-patterns, or excessive coupling.

## When to Activate
- Implementing a new `GetxController`.
- Configuring dependency injection with `Bindings`.
- Setting up named routes, parameters, or transitions with `AppPages`.
- Debugging state updates, reactive observables (`Rx`), or controller lifecycles.

## Core Patterns

### 1. Controller Design
```dart
class MyFeatureController extends GetxController {
  final MyFeatureRepository _repository;

  MyFeatureController({required MyFeatureRepository repository})
      : _repository = repository;

  // 1. Reactive state variables
  final RxList<MyItem> items = <MyItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  @override
  void onClose() {
    // Clean up streams or timers if any
    super.onClose();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.getItems();
      items.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
```

### 2. Dependency Injection via Bindings
Always use `Get.lazyPut()` within `Bindings` so that controllers are instantiated on demand and disposed when the screen leaves the navigation stack:
```dart
class MyFeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyFeatureDataSource>(
      () => MyFeatureDataSourceImpl(Get.find<DioClient>()),
    );
    Get.lazyPut<MyFeatureRepository>(
      () => MyFeatureRepositoryImpl(Get.find<MyFeatureDataSource>()),
    );
    Get.lazyPut<MyFeatureController>(
      () => MyFeatureController(repository: Get.find<MyFeatureRepository>()),
    );
  }
}
```

### 3. Lean Views (`GetView<TController>`)
```dart
class MyFeatureView extends GetView<MyFeatureController> {
  const MyFeatureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoadingIndicator();
        }
        if (controller.errorMessage.value != null) {
          return AppErrorView(
            message: controller.errorMessage.value!,
            onRetry: controller.fetchItems,
          );
        }
        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) => Text(controller.items[index].title),
        );
      }),
    );
  }
}
```

### 4. Navigation & Named Routes
Always navigate with named routes to preserve deep-linking capabilities:
```dart
Get.toNamed(AppRoutes.postDetails, parameters: {'id': '123'});
Get.back();
Get.offNamed(AppRoutes.home);
```

## Anti-Patterns to Strictly Avoid
- **Never call `Get.put()` inside `build()`**: This causes memory leaks and re-instantiation on every widget rebuild.
- **Do not use `GetBuilder` unless micro-optimizing**: Prefer `Rx` observables with `Obx` for fine-grained reactivity.
- **Never use global navigation context inside domain models**: Keep domain independent of `Get.context` or `Get.to`.

## Verification Checklist
- [ ] View extends `GetView<ControllerName>`.
- [ ] Controller dependencies are injected in constructor.
- [ ] Binding uses `Get.lazyPut()`.
- [ ] Route is registered in `AppPages`.
- [ ] `Obx` is scoped only around reactive widgets.

