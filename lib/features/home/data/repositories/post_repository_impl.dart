import 'package:base_flutter_ai/core/errors/error_handler.dart';
import 'package:base_flutter_ai/features/home/data/datasources/post_remote_datasource.dart';
import 'package:base_flutter_ai/features/home/domain/entities/post_entity.dart';
import 'package:base_flutter_ai/features/home/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;

  PostRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PostEntity>> getPosts() async {
    try {
      final models = await _remoteDataSource.fetchPosts();
      return models.map((m) => m.toEntity()).toList();
    } catch (e, st) {
      final failure = ErrorHandler.handle(e, st);
      throw failure;
    }
  }

  @override
  Future<PostEntity> getPostById(int id) async {
    try {
      final model = await _remoteDataSource.fetchPostById(id);
      return model.toEntity();
    } catch (e, st) {
      final failure = ErrorHandler.handle(e, st);
      throw failure;
    }
  }
}
