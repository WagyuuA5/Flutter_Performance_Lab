import 'package:flutter/material.dart';

class CaseAnimationJankScreen extends StatelessWidget {
  const CaseAnimationJankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Case 7: Animation Jank'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Before (Rebuild All)'),
              Tab(text: 'After (Child Param)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BeforeAnimationJank(),
            _AfterAnimationJank(),
          ],
        ),
      ),
    );
  }
}

class _BeforeAnimationJank extends StatefulWidget {
  const _BeforeAnimationJank();

  @override
  State<_BeforeAnimationJank> createState() => _BeforeAnimationJankState();
}

class _BeforeAnimationJankState extends State<_BeforeAnimationJank> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _buildCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'This tab rebuilds the ENTIRE heavy tree 60 times a second.\n'
            'Check the red build counter on the heavy widget.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          // BAD: The AnimatedBuilder doesn't use the `child` parameter.
          // Everything inside `builder` is rebuilt on every animation tick!
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              _buildCount++; // We increment just to show it's being rebuilt constantly
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: Center(
                  child: _HeavyTreeWidget(
                    buildCount: _buildCount,
                    isOptimized: false,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AfterAnimationJank extends StatefulWidget {
  const _AfterAnimationJank();

  @override
  State<_AfterAnimationJank> createState() => _AfterAnimationJankState();
}

class _AfterAnimationJankState extends State<_AfterAnimationJank> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _buildCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'This tab uses the `child` parameter.\n'
            'The heavy widget builds ONCE, only the Transform is animated.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          // GOOD: We pass the expensive widget tree to `child`.
          // The `builder` closure only rebuilds the Transform.
          child: AnimatedBuilder(
            animation: _controller,
            child: Center(
              child: _HeavyTreeWidget(
                buildCount: _buildCount,
                isOptimized: true,
              ),
            ),
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HeavyTreeWidget extends StatelessWidget {
  final int buildCount;
  final bool isOptimized;

  const _HeavyTreeWidget({
    required this.buildCount,
    required this.isOptimized,
  });

  @override
  Widget build(BuildContext context) {
    // We simulate a heavy widget that takes effort to build.
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: isOptimized ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings, size: 50, color: Colors.black54),
          const SizedBox(height: 16),
          Text(
            'Builds: $buildCount',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isOptimized ? Colors.green.shade900 : Colors.red.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isOptimized ? 'O(1) build' : 'O(N) builds/sec',
            style: const TextStyle(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
