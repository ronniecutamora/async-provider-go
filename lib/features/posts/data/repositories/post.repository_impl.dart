import 'package:async_provider_go/features/posts/data/data_sources/post.service.dart';
import 'package:async_provider_go/features/posts/domain/models/post.model.dart';
import 'package:async_provider_go/features/posts/domain/repositories/post.repository.dart';

/// Concrete implementation. All error handling lives here so that
/// the Provider only ever receives clean data or a friendly exception.
class PostRepositoryImpl implements PostRepository {
  final PostService _service;

  PostRepositoryImpl(this._service);

  @override
  Future<List<Post>> getPosts() async {
    try {
      return await _service.fetchPosts();
    } catch (e) {
      throw Exception('Failed to load posts.');
    }
  }

  @override
  Future<Post> getPostById(int id) async {
    try {
      return await _service.fetchPostById(id);
    } catch (e) {
      throw Exception('Failed to load post #$id.');
    }
  }
}