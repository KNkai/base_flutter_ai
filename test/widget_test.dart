import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:base_flutter_ai/app/app.dart';
import 'package:base_flutter_ai/core/config/app_config.dart';
import 'package:base_flutter_ai/core/config/env_config.dart';
import 'package:base_flutter_ai/features/home/domain/entities/post_entity.dart';
import 'package:base_flutter_ai/features/home/domain/repositories/post_repository.dart';
import 'package:base_flutter_ai/features/home/presentation/controllers/home_controller.dart';

class TestPostRepository implements PostRepository {
  @override
  Future<List<PostEntity>> getPosts() async {
    return const [
      PostEntity(
        id: 1,
        userId: 1,
        title: 'Smoke Test Title',
        body: 'Smoke Test Body',
      ),
    ];
  }

  @override
  Future<PostEntity> getPostById(int id) async {
    return const PostEntity(
      id: 1,
      userId: 1,
      title: 'Smoke Test Title',
      body: 'Smoke Test Body',
    );
  }
}

void main() {
  setUp(() {
    AppConfig.initialize(
      const EnvConfig(
        environment: Environment.dev,
        appTitle: 'Flutter AI Smoke Test',
        apiBaseUrl: 'https://test.example.com',
      ),
    );
    // Pre-bind test repository so App doesn't attempt real network I/O during smoke test
    Get.lazyPut<PostRepository>(() => TestPostRepository());
    Get.lazyPut<HomeController>(
      () => HomeController(postRepository: Get.find<PostRepository>()),
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('App root smoke test mounts successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.byType(App), findsOneWidget);
    expect(find.text('Smoke Test Title'), findsOneWidget);
  });
}
