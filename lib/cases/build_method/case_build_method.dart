import 'package:flutter/material.dart';

class CaseBuildMethodScreen extends StatelessWidget {
  const CaseBuildMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Case 4: Heavy Build Method'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Before (Compute in build)'),
              Tab(text: 'After (Precompute)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BeforeBuildMethod(),
            _AfterBuildMethod(),
          ],
        ),
      ),
    );
  }
}

class _BeforeBuildMethod extends StatefulWidget {
  const _BeforeBuildMethod();

  @override
  State<_BeforeBuildMethod> createState() => _BeforeBuildMethodState();
}

class _BeforeBuildMethodState extends State<_BeforeBuildMethod> {
  final List<int> _rawData = List.generate(100000, (index) => index);
  bool _ascending = true;
  int _buildCount = 0;

  List<int> _heavyComputation() {
    final sw = Stopwatch()..start();
    // Simulate an expensive filter & sort operation every time build is called
    final result = _rawData
        .where((e) => e % 2 == 0) // filter even
        .toList()
      ..sort((a, b) => _ascending ? a.compareTo(b) : b.compareTo(a));
    sw.stop();
    debugPrint('Before Build Computation took: ${sw.elapsedMilliseconds} ms');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    // DANGER: Heavy computation directly inside build method!
    // This will lock the main thread during every frame this widget rebuilds.
    final sw = Stopwatch()..start();
    final data = _heavyComputation();
    sw.stop();

    return Column(
      children: [
        _MetricsHeader(
          buildCount: _buildCount,
          computationTimeMs: sw.elapsedMilliseconds,
          onToggleSort: () => setState(() => _ascending = !_ascending),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 100, // Just show top 100
            itemBuilder: (context, index) {
              return ListTile(title: Text('Item ${data[index]}'));
            },
          ),
        ),
      ],
    );
  }
}

class _AfterBuildMethod extends StatefulWidget {
  const _AfterBuildMethod();

  @override
  State<_AfterBuildMethod> createState() => _AfterBuildMethodState();
}

class _AfterBuildMethodState extends State<_AfterBuildMethod> {
  final List<int> _rawData = List.generate(100000, (index) => index);
  bool _ascending = true;
  int _buildCount = 0;
  
  List<int> _processedData = [];
  int _lastComputationTime = 0;

  @override
  void initState() {
    super.initState();
    _computeData();
  }

  void _computeData() {
    final sw = Stopwatch()..start();
    _processedData = _rawData
        .where((e) => e % 2 == 0)
        .toList()
      ..sort((a, b) => _ascending ? a.compareTo(b) : b.compareTo(a));
    sw.stop();
    _lastComputationTime = sw.elapsedMilliseconds;
  }

  void _toggleSort() {
    setState(() {
      _ascending = !_ascending;
      // Precompute ONLY when data actually needs to change, not on every build
      _computeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    // FAST: build method only reads already computed data.
    final sw = Stopwatch()..start();
    final data = _processedData;
    sw.stop();

    return Column(
      children: [
        _MetricsHeader(
          buildCount: _buildCount,
          computationTimeMs: sw.elapsedMilliseconds,
          cachedComputationTimeMs: _lastComputationTime,
          onToggleSort: _toggleSort,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 100, // Just show top 100
            itemBuilder: (context, index) {
              return ListTile(title: Text('Item ${data[index]}'));
            },
          ),
        ),
      ],
    );
  }
}

class _MetricsHeader extends StatelessWidget {
  final int buildCount;
  final int computationTimeMs;
  final int? cachedComputationTimeMs;
  final VoidCallback onToggleSort;

  const _MetricsHeader({
    required this.buildCount,
    required this.computationTimeMs,
    this.cachedComputationTimeMs,
    required this.onToggleSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.shade100,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Builds: $buildCount', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Time spent in build(): $computationTimeMs ms', 
               style: TextStyle(color: computationTimeMs > 5 ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
          if (cachedComputationTimeMs != null)
            Text('(Precomputation took: $cachedComputationTimeMs ms before build)'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onToggleSort,
            child: const Text('Toggle Sort (Triggers Rebuild)'),
          ),
        ],
      ),
    );
  }
}
