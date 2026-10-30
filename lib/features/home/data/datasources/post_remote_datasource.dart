import 'package:base_flutter_ai/core/constants/api_endpoints.dart';
import 'package:base_flutter_ai/core/errors/exceptions.dart';
import 'package:base_flutter_ai/core/network/dio_client.dart';
import 'package:base_flutter_ai/features/home/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> fetchPosts();
  Future<PostModel> fetchPostById(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final DioClient _client;

  PostRemoteDataSourceImpl(this._client);

  @override
  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await _client.get<dynamic>(ApiEndpoints.posts);
      if (response.data is List) {
        final list = response.data as List<dynamic>;
        return list
            .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      return _fallbackSamplePosts();
    } on AppException {
      rethrow;
    } catch (e) {
      // In case the mock endpoint is unreachable in local dev, provide safe fallback
      return _fallbackSamplePosts();
    }
  }

  @override
  Future<PostModel> fetchPostById(int id) async {
    try {
      final response = await _client.get<dynamic>(
        ApiEndpoints.postDetails.replaceAll('{id}', id.toString()),
      );
      if (response.data is Map) {
        return PostModel.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
      }
      return _fallbackSamplePosts().firstWhere(
        (p) => p.id == id,
        orElse: () => _fallbackSamplePosts().first,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      return _fallbackSamplePosts().firstWhere(
        (p) => p.id == id,
        orElse: () => _fallbackSamplePosts().first,
      );
    }
  }

  List<PostModel> _fallbackSamplePosts() {
    return const [
      PostModel(
        id: 1,
        userId: 1,
        title: 'Mastering Flutter Architecture with GetX and Dio',
        body: 'Learn how to structure maintainable, scalable Flutter enterprise applications with clean layer boundaries.',
        views: 1250,
        rating: 4.9,
      ),
      PostModel(
        id: 2,
        userId: 1,
        title: 'Agentic AI Workflows in Software Development',
        body: 'Empower autonomous agents with domain-specific skills, strict validation, and resilient tooling.',
        views: 980,
        rating: 4.8,
      ),
      PostModel(
        id: 3,
        userId: 2,
        title: 'Resilient Networking and Centralized Error Handling',
        body: 'How to intercept Dio requests, inject secure tokens, and map network failures gracefully to UI states.',
        views: 740,
        rating: 4.7,
      ),
    ];
  }
}
