import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CaseImageScreen extends StatelessWidget {
  const CaseImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Case 3: Unoptimized Images'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Before (Raw Network)'),
              Tab(text: 'After (Cached & Resized)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BeforeImages(),
            _AfterImages(),
          ],
        ),
      ),
    );
  }
}

class _BeforeImages extends StatelessWidget {
  const _BeforeImages();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        // High resolution image loaded as-is
        final imageUrl = 'https://picsum.photos/seed/$index/1200/1200';
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
        );
      },
    );
  }
}

class _AfterImages extends StatelessWidget {
  const _AfterImages();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        final imageUrl = 'https://picsum.photos/seed/$index/1200/1200';
        return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          // Decode image to a smaller size in memory (around physical pixels needed)
          memCacheWidth: 300, 
          memCacheHeight: 300,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      },
    );
  }
}
