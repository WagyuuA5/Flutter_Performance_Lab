import 'package:flutter/material.dart';

class CaseRebuildScreen extends StatelessWidget {
  const CaseRebuildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Case 1: Excessive Rebuilds'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Before (setState root)'),
              Tab(text: 'After (Localized)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BeforeRebuilds(),
            _AfterRebuilds(),
          ],
        ),
      ),
    );
  }
}

class RebuildTrackerWidget extends StatefulWidget {
  final Widget child;
  const RebuildTrackerWidget({super.key, required this.child});

  @override
  State<RebuildTrackerWidget> createState() => _RebuildTrackerWidgetState();
}

class _RebuildTrackerWidgetState extends State<RebuildTrackerWidget> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Builds: $_rebuildCount', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          widget.child,
        ],
      ),
    );
  }
}

class _BeforeRebuilds extends StatefulWidget {
  const _BeforeRebuilds();

  @override
  State<_BeforeRebuilds> createState() => _BeforeRebuildsState();
}

class _BeforeRebuildsState extends State<_BeforeRebuilds> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RebuildTrackerWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('This whole column rebuilds on tap!'),
          const SizedBox(height: 20),
          Text('Counter: $_counter', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _incrementCounter,
            child: const Text('Increment'),
          ),
          const SizedBox(height: 20),
          const _HeavyWidgetDummy(),
        ],
      ),
    );
  }
}

class _AfterRebuilds extends StatefulWidget {
  const _AfterRebuilds();

  @override
  State<_AfterRebuilds> createState() => _AfterRebuildsState();
}

class _AfterRebuildsState extends State<_AfterRebuilds> {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  void _incrementCounter() {
    _counter.value++;
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RebuildTrackerWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Only the text widget rebuilds!'),
          const SizedBox(height: 20),
          ValueListenableBuilder<int>(
            valueListenable: _counter,
            builder: (context, value, child) {
              return RebuildTrackerWidget(
                child: Text('Counter: $value', style: Theme.of(context).textTheme.headlineMedium),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _incrementCounter,
            child: const Text('Increment'),
          ),
          const SizedBox(height: 20),
          const _HeavyWidgetDummy(),
        ],
      ),
    );
  }
}

class _HeavyWidgetDummy extends StatelessWidget {
  const _HeavyWidgetDummy();

  @override
  Widget build(BuildContext context) {
    return const RebuildTrackerWidget(
      child: Text('I am a heavy static widget that should not rebuild.'),
    );
  }
}
