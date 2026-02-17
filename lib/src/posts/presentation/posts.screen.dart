import 'package:async_provider_go/src/posts/presentation/posts.provider.dart';
import 'package:async_provider_go/src/posts/presentation/widgets/post_card.dart';
import 'package:async_provider_go/src/posts/presentation/widgets/post_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PostProvider>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("My Blog")),
      body: RefreshIndicator(
        onRefresh: () => context.read<PostProvider>().loadPosts(),
        child: switch (state) {
          // posts initial state
          PostInitial() => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7, // Centers the text visually
                  child: const Center(child: Text("Pull down to load posts")),
                ),
              ],
            ),
          // posts loading
          PostLoading() => const PostShimmerList(), 
          // posts error
          PostError(message: var m) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text(m)),
                ),
              ],
            ),
          // posts loaded
          PostLoaded(posts: var list) => ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(), 
              itemCount: list.length,
              itemBuilder: (context, index) {
                final post = list[index];
                return PostCard(post: post); 
              },
            ),
        },
      ),
    );
  }
}