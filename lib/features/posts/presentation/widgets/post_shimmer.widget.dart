import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Renders [itemCount] skeleton cards that visually match [PostCard].
///
/// Pass [PostProvider.shimmerCount] so the count mirrors the real list length.
class PostShimmerList extends StatelessWidget {
  const PostShimmerList({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, __) => const PostShimmerItem(),
    );
  }
}

/// A single shimmer skeleton that mirrors the layout of [PostCard].
class PostShimmerItem extends StatelessWidget {
  const PostShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[300]!;
    final highlight = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[600]!
        : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mirrors CircleAvatar radius: 24 → diameter 48
            Container(
              width: 48.0,
              height: 48.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  // Title line
                  Container(
                    width: double.infinity,
                    height: 14.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8.0),
                  // Subtitle line
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 14.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}