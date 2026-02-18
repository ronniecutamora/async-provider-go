import 'package:async_provider_go/features/posts/domain/models/post.model.dart';

/// Mock data service — swap the implementations here when
/// connecting to a real backend (Supabase / REST). Nothing above
/// this layer changes.
class PostService {
  static const List<Post> _posts = [
    Post(
      id: 1,
      title: 'Building Scalable Flutter Apps',
      body:
          'Scalability in Flutter starts with a clear separation of concerns. '
          'By adopting Clean Architecture, each layer — domain, data, and '
          'presentation — evolves independently, making large teams and '
          'long-lived codebases far easier to maintain.',
      userId: 10,
    ),
    Post(
      id: 2,
      title: 'The Power of Sealed Classes',
      body:
          'Sealed classes in Dart let you model a finite set of states with '
          'exhaustive pattern matching. Combined with switch expressions, they '
          'eliminate entire categories of UI bugs by forcing you to handle '
          'every possible state at compile time.',
      userId: 10,
    ),
    Post(
      id: 3,
      title: 'Why Shimmers Beat Spinners',
      body:
          'A shimmer skeleton keeps the layout stable while data loads, giving '
          'users a sense of content structure before it arrives. Spinners '
          'provide no spatial information and feel slower even when they aren\'t.',
      userId: 11,
    ),
    Post(
      id: 4,
      title: 'Clean Architecture for Teams',
      body:
          'When multiple developers work on the same feature, clear layer '
          'boundaries prevent merge conflicts and accidental coupling. The '
          'domain layer acts as a shared contract that both the data and '
          'presentation teams code against simultaneously.',
      userId: 12,
    ),
    Post(
      id: 5,
      title: 'Advanced Provider Techniques',
      body:
          'ProxyProvider enables true dependency injection in Flutter without '
          'a service locator. Combining it with ChangeNotifierProxyProvider '
          'gives you reactive ViewModels that are fully testable and '
          'decoupled from their data sources.',
      userId: 12,
    ),
  ];

  Future<List<Post>> fetchPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    return _posts;
  }

  Future<Post> fetchPostById(int id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _posts.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Post with id $id not found.'),
    );
  }
}