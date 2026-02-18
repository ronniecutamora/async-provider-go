import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/post.provider.dart';

/// Displays the full content of a single post.
///
/// Passive view — all data fetching is delegated to [PostProvider].
/// Uses a switch expression to guarantee every [PostDetailState] is handled.
class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch after the first frame so the Provider tree is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadPost(int.parse(widget.postId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailState = context.watch<PostProvider>().detailState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: switch (detailState) {
        PostDetailInitial() => const SizedBox.shrink(),
        PostDetailLoading() => const Center(child: CircularProgressIndicator()),
        PostDetailError(message: var m) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(m, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context
                        .read<PostProvider>()
                        .loadPost(int.parse(widget.postId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        PostDetailLoaded(post: var post) => SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Text(
                        post.userId.toString(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'User ${post.userId}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  post.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  post.body,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
      },
    );
  }
}