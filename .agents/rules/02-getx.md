# Rule 02: GetX State Management & Routing

1. **State Management**:
   - Use `GetxController` for screen/feature logic.
   - Declare state as reactive observables (`RxInt`, `RxBool`, `RxString`, `RxList`).
   - Use `Obx(() => ...)` only around specific widgets that observe reactive state. Do not wrap entire scaffolds in `Obx`.
2. **Dependency Injection**:
   - Register dependencies using `Bindings` and `Get.lazyPut()`.
   - Never call `Get.put()` directly inside a widget's `build()` method.
   - For long-lived global services, extend `GetxService` and initialize in `InitialBinding` or `bootstrapApp`.
3. **Routing**:
   - Always use **GetX Named Routing**.
   - Define route strings as constants in `AppRoutes`.
   - Configure all routes in `AppPages` with their respective `Binding`.
   - Navigate with `Get.toNamed(AppRoutes.xyz)` rather than raw `Navigator.push`.

