import '../models/post.model.dart';

// The "Contract" - anyone using the repository only sees these methods.
abstract class PostRepository {
  Future<List<Post>> getPosts();
}