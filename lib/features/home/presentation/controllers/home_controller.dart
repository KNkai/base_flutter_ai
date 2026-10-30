import 'package:get/get.dart';
import 'package:base_flutter_ai/core/errors/failures.dart';
import 'package:base_flutter_ai/core/utils/logger.dart';
import 'package:base_flutter_ai/features/home/domain/entities/post_entity.dart';
import 'package:base_flutter_ai/features/home/domain/repositories/post_repository.dart';

class HomeController extends GetxController {
  final PostRepository postRepository;

  HomeController({required this.postRepository});

  final RxList<PostEntity> _posts = <PostEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxnString _errorMessage = RxnString();
  final RxString _searchQuery = ''.obs;

  List<PostEntity> get posts => _posts;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;

  List<PostEntity> get filteredPosts {
    if (_searchQuery.isEmpty) return _posts;
    final query = _searchQuery.value.toLowerCase();
    return _posts.where((post) {
      return post.title.toLowerCase().contains(query) ||
          post.body.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      final result = await postRepository.getPosts();
      _posts.assignAll(result);
      AppLogger.i('Fetched ${_posts.length} posts successfully');
    } catch (e) {
      if (e is Failure) {
        _errorMessage.value = e.message;
      } else {
        _errorMessage.value = e.toString();
      }
      AppLogger.e('Failed to fetch posts: ${_errorMessage.value}', e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void clearSearch() {
    _searchQuery.value = '';
  }
}
