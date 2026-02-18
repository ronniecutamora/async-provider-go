/// Core domain entity for a Post.
/// No Flutter dependencies — pure Dart.
class Post {
  final int id;
  final String title;
  final String body;
  final int userId;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });
}