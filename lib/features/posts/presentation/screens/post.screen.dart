import 'package:async_provider_go/features/posts/presentation/widgets/post_card.widget.dart';
import 'package:async_provider_go/features/posts/presentation/widgets/post_shimmer.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post.provider.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PostProvider>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("Blog")),
      body: RefreshIndicator(
        onRefresh: () => context.read<PostProvider>().loadPosts(),
        child: switch (state) {
          PostInitial() => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(child: Text("Pull down to load posts")),
                ),
              ],
            ),
          PostLoading() => const PostShimmerList(), 
          PostError(message: var m) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text(m)),
                ),
              ],
            ),
          PostLoaded(posts: var list) => ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(), 
              itemCount: list.length,
              itemBuilder: (context, index) => PostCard(post: list[index]),
            ),
        },
      ),
    );
  }
}