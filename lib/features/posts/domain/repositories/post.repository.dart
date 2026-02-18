import '../models/post.model.dart';

/// The contract — the presentation layer only ever depends on this interface,
/// never on the concrete implementation or the data source.
abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(int id);
}