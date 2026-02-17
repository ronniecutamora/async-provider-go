
import 'package:async_provider_go/features/posts/domain/models/post.model.dart';

class PostService {
  Future<List<Post>> fetchPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Post(id: 1, title: "Building Scalable Flutter Apps", userId: 10),
      Post(id: 2, title: "The Power of Sealed Classes", userId: 10),
      Post(id: 3, title: "Why Shimmers beat Spinners", userId: 11),
      Post(id: 4, title: "Clean Architecture for Teams", userId: 12),
      Post(id: 5, title: "Advanced Provider Techniques", userId: 12),
    ];
  }
}