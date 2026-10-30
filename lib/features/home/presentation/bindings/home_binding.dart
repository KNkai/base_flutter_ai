import 'package:get/get.dart';
import 'package:base_flutter_ai/core/network/dio_client.dart';
import 'package:base_flutter_ai/features/home/data/datasources/post_remote_datasource.dart';
import 'package:base_flutter_ai/features/home/data/repositories/post_repository_impl.dart';
import 'package:base_flutter_ai/features/home/domain/repositories/post_repository.dart';
import 'package:base_flutter_ai/features/home/presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(Get.find<DioClient>()),
    );

    Get.lazyPut<PostRepository>(
      () => PostRepositoryImpl(Get.find<PostRemoteDataSource>()),
    );

    Get.lazyPut<HomeController>(
      () => HomeController(postRepository: Get.find<PostRepository>()),
    );
  }
}
