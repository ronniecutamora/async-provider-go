import 'package:async_provider_go/features/posts/data/data_sources/post.service.dart';
import 'package:async_provider_go/features/posts/domain/repositories/post.repository.dart';
import '../../domain/models/post.model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostService _service;

  PostRepositoryImpl(this._service);

  @override
  Future<List<Post>> getPosts() async {
    try {
      // In a real app, you'd handle JSON mapping and local caching here
      return await _service.fetchPosts();
    } catch (e) {
      throw Exception("Failed to sync posts from server.");
    }
  }
}