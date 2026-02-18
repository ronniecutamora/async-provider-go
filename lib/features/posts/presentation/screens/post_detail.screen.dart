import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Displays the full content of a single post.
///
/// Navigate here via:
/// ```dart
/// context.go(AppRoutes.postDetailPath(post.id.toString()));
/// // or by name:
/// context.goNamed(AppRouteNames.postDetail, pathParameters: {'id': '${post.id}'});
/// ```
class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post #$postId'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Center(
        child: Text(
          'Detail view for post $postId',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}