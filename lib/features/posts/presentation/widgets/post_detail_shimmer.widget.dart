import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton loader for [PostDetailScreen].
///
/// Mirrors the detail layout: avatar row → title block → body lines.
class PostDetailShimmer extends StatelessWidget {
  const PostDetailShimmer({super.key});

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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mirrors avatar + "User X" row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 80, height: 14, color: Colors.white),
              ],
            ),
            const SizedBox(height: 24),
            // Mirrors headlineSmall title (can wrap to 2 lines)
            Container(width: double.infinity, height: 22, color: Colors.white),
            const SizedBox(height: 10),
            Container(width: 200, height: 22, color: Colors.white),
            const SizedBox(height: 24),
            // Mirrors body paragraph lines
            for (int i = 0; i < 6; i++) ...[
              Container(
                width: i == 5
                    ? MediaQuery.of(context).size.width * 0.6
                    : double.infinity,
                height: 14,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}