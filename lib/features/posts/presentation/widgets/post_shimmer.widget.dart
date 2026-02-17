import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class PostShimmerList extends StatelessWidget {
  const PostShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //TODO: pass the actual list length here
      itemCount: 10, // Show 6 skeleton items while loading
      itemBuilder: (context, index) => const PostShimmerItem(),
    );
  }
}
class PostShimmerItem extends StatelessWidget {
  const PostShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fake Leading Icon/Image
            Container(
              width: 48.0,
              height: 48.0,
              color: Colors.white,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fake Title line
                  Container(
                    width: double.infinity,
                    height: 14.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8.0),
                  // Fake Subtitle line (shorter)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 14.0,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
