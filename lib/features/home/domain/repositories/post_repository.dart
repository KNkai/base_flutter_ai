import 'package:base_flutter_ai/features/home/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();
  Future<PostEntity> getPostById(int id);
}
