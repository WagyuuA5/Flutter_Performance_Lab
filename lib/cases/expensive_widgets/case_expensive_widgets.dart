import 'package:flutter/material.dart';

class CaseExpensiveWidgetsScreen extends StatelessWidget {
  const CaseExpensiveWidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Case 5: Expensive Widgets'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Before (Opacity & Clip)'),
              Tab(text: 'After (Optimized)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BeforeExpensiveWidgets(),
            _AfterExpensiveWidgets(),
          ],
        ),
      ),
    );
  }
}

class _BeforeExpensiveWidgets extends StatelessWidget {
  const _BeforeExpensiveWidgets();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        // EXPENSIVE: Opacity forces an offscreen buffer (saveLayer)
        return Opacity(
          opacity: 0.5,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            // EXPENSIVE: BoxShadow without optimization forces multiple repaints
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            // EXPENSIVE: ClipRRect can be slow if used on complex subtrees unnecessarily
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Container(width: 100, color: Colors.blue),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Expensive Composite Operations'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AfterExpensiveWidgets extends StatelessWidget {
  const _AfterExpensiveWidgets();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        // CHEAP: RepaintBoundary isolates this complex widget so it isn't repainted if parent repaints
        return RepaintBoundary(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            height: 100,
            // CHEAP: Bake opacity directly into colors if possible (0.5 opacity = withOpacity(0.5))
            // CHEAP: Use DecoratedBox with BoxShape and optimized shadows instead of ClipRRect where possible
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withValues(alpha: 0.13), // Adjusted for 0.5 opacity
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias, // Clip directly on the container is generally more optimized
            child: Row(
              children: [
                Container(width: 100, color: Colors.blue.withValues(alpha: 0.5)),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Optimized Rendering', style: TextStyle(color: Colors.black54)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
