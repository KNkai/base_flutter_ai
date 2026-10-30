import 'package:get/get.dart';
import 'package:base_flutter_ai/core/network/dio_client.dart';
import 'package:base_flutter_ai/core/storage/secure_storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Network Client
    Get.lazyPut<DioClient>(
      () => DioClient(
        secureStorage: Get.isRegistered<SecureStorageService>()
            ? Get.find<SecureStorageService>()
            : null,
      ),
      fenix: true,
    );
  }
}
