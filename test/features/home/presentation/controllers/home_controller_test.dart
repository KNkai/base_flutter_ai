import 'package:flutter_test/flutter_test.dart';
import 'package:base_flutter_ai/core/errors/failures.dart';
import 'package:base_flutter_ai/features/home/domain/entities/post_entity.dart';
import 'package:base_flutter_ai/features/home/domain/repositories/post_repository.dart';
import 'package:base_flutter_ai/features/home/presentation/controllers/home_controller.dart';

class FakePostRepository implements PostRepository {
  List<PostEntity> mockPosts = [];
  bool shouldThrow = false;
  Failure failureToThrow = const ServerFailure(
    message: 'Server error occurred',
  );

  @override
  Future<List<PostEntity>> getPosts() async {
    if (shouldThrow) {
      throw failureToThrow;
    }
    return mockPosts;
  }

  @override
  Future<PostEntity> getPostById(int id) async {
    if (shouldThrow) {
      throw failureToThrow;
    }
    return mockPosts.firstWhere((p) => p.id == id);
  }
}

void main() {
  group('HomeController Unit Tests', () {
    late FakePostRepository fakeRepository;
    late HomeController controller;

    final samplePosts = [
      const PostEntity(
        id: 1,
        userId: 1,
        title: 'Flutter Architecture',
        body: 'Clean architecture with GetX and Dio',
        views: 100,
        rating: 4.9,
      ),
      const PostEntity(
        id: 2,
        userId: 1,
        title: 'Dart 3 Patterns',
        body: 'Pattern matching and records in Dart',
        views: 80,
        rating: 4.8,
      ),
    ];

    setUp(() {
      fakeRepository = FakePostRepository();
      fakeRepository.mockPosts = samplePosts;
      controller = HomeController(postRepository: fakeRepository);
    });

    test('initialization calls fetchPosts and populates posts list', () async {
      await controller.fetchPosts();

      expect(controller.posts.length, 2);
      expect(controller.isLoading, isFalse);
      expect(controller.errorMessage, isNull);
    });

    test(
      'fetchPosts sets errorMessage when repository throws Failure',
      () async {
        fakeRepository.shouldThrow = true;
        fakeRepository.failureToThrow = const NetworkFailure(
          message: 'No internet connection',
        );

        await controller.fetchPosts();

        expect(controller.posts, isEmpty);
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, 'No internet connection');
      },
    );

    test('filteredPosts filters items based on searchQuery', () async {
      await controller.fetchPosts();

      controller.updateSearchQuery('Dart');
      expect(controller.filteredPosts.length, 1);
      expect(controller.filteredPosts.first.title, 'Dart 3 Patterns');

      controller.updateSearchQuery('NonExistent');
      expect(controller.filteredPosts, isEmpty);

      controller.clearSearch();
      expect(controller.filteredPosts.length, 2);
    });
  });
}
