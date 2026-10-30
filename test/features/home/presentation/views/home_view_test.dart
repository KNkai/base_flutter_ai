import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:base_flutter_ai/core/config/app_config.dart';
import 'package:base_flutter_ai/core/config/env_config.dart';
import 'package:base_flutter_ai/core/errors/failures.dart';
import 'package:base_flutter_ai/core/widgets/app_error_view.dart';
import 'package:base_flutter_ai/core/widgets/app_loading_indicator.dart';
import 'package:base_flutter_ai/features/home/domain/entities/post_entity.dart';
import 'package:base_flutter_ai/features/home/domain/repositories/post_repository.dart';
import 'package:base_flutter_ai/features/home/presentation/controllers/home_controller.dart';
import 'package:base_flutter_ai/features/home/presentation/views/home_view.dart';
import 'package:base_flutter_ai/features/home/presentation/widgets/post_card.dart';

class MockHomeRepository implements PostRepository {
  List<PostEntity> posts = [];
  bool throwError = false;
  Completer<List<PostEntity>>? pendingCompleter;

  @override
  Future<List<PostEntity>> getPosts() async {
    if (pendingCompleter != null) {
      return pendingCompleter!.future;
    }
    if (throwError) {
      throw const NetworkFailure(message: 'Connection failed');
    }
    return posts;
  }

  @override
  Future<PostEntity> getPostById(int id) async {
    return posts.first;
  }
}

void main() {
  setUpAll(() {
    AppConfig.initialize(
      const EnvConfig(
        environment: Environment.dev,
        appTitle: 'Test App',
        apiBaseUrl: 'https://test.example.com',
      ),
    );
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest() {
    return const GetMaterialApp(home: HomeView());
  }

  testWidgets('renders home header and post cards when data is loaded', (
    tester,
  ) async {
    final repo = MockHomeRepository();
    repo.posts = const [
      PostEntity(
        id: 1,
        userId: 1,
        title: 'Mastering Flutter Architecture',
        body: 'Clean architecture with GetX and Dio',
        views: 200,
        rating: 4.9,
      ),
    ];

    Get.put<HomeController>(HomeController(postRepository: repo));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Starter Kit Dashboard'), findsOneWidget);
    expect(find.text('Production-Grade Flutter + AI'), findsOneWidget);
    expect(find.text('Mastering Flutter Architecture'), findsOneWidget);
    expect(find.byType(PostCard), findsOneWidget);
  });

  testWidgets('renders loading indicator when controller isLoading is true', (
    tester,
  ) async {
    final repo = MockHomeRepository();
    final completer = Completer<List<PostEntity>>();
    repo.pendingCompleter = completer;

    Get.put<HomeController>(HomeController(postRepository: repo));

    await tester.pumpWidget(createWidgetUnderTest());
    // Pump one frame to render the loading view while the completer is pending
    await tester.pump();

    expect(find.byType(AppLoadingIndicator), findsOneWidget);

    // Complete the future to clean up pending timers
    completer.complete([]);
    await tester.pumpAndSettle();
  });

  testWidgets('renders AppErrorView when repository fails', (tester) async {
    final repo = MockHomeRepository();
    repo.throwError = true;

    Get.put<HomeController>(HomeController(postRepository: repo));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.text('Connection failed'), findsOneWidget);
  });
}
