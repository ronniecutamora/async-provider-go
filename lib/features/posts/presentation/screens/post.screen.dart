import 'package:async_provider_go/core/widgets/error_view.dart';
import 'package:async_provider_go/core/theme/theme.provider.dart';
import 'package:async_provider_go/features/posts/presentation/widgets/post_card.widget.dart';
import 'package:async_provider_go/features/posts/presentation/widgets/post_shimmer.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post.provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final PostProvider _postProvider; // save reference

  @override
  void initState() {
    super.initState();
    _postProvider = context.read<PostProvider>();
    _postProvider.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _postProvider.removeListener(_onStateChanged); // use saved reference
    super.dispose();
  }

  void _onStateChanged() {
    final state = context.read<PostProvider>().state;
    if (state is PostError) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(state.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    }
  }

  Future<void> _onRefresh() async {
    await context.read<PostProvider>().loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();
    final state = provider.state;
    final shimmerCount = provider.shimmerCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        actions: [
          // Dark mode toggle — wires up to ThemeProvider
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(
              context.watch<ThemeProvider>().isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: context.read<ThemeProvider>().toggleTheme,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: switch (state) {
          PostInitial() => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(child: Text('Pull down to load posts')),
                ),
              ],
            ),
          PostLoading() => PostShimmerList(itemCount: shimmerCount),
          PostError(message: var m) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ErrorView(
                    message: m,
                    onRetry: _onRefresh,
                  ),
                ),
              ],
            ),
          PostLoaded(posts: var list) => ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (_, index) => PostCard(post: list[index]),
            ),
        },
      ),
    );
  }
}