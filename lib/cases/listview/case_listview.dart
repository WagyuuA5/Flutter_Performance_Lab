import 'package:flutter/material.dart';

class CaseListViewScreen extends StatelessWidget {
  const CaseListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Case 2: Expensive ListView'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Before (ListView)'),
              Tab(text: 'After (builder)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BeforeListView(),
            _AfterListView(),
          ],
        ),
      ),
    );
  }
}

class _BeforeListView extends StatefulWidget {
  const _BeforeListView();

  @override
  State<_BeforeListView> createState() => _BeforeListViewState();
}

class _BeforeListViewState extends State<_BeforeListView> {
  final Stopwatch _stopwatch = Stopwatch();
  Duration? _buildTime;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stopwatch.stop();
      if (mounted) {
        setState(() {
          _buildTime = _stopwatch.elapsed;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Restart stopwatch on every build to measure rebuilds if needed, 
    // but here we just measure initial frame time.
    final items = List.generate(5000, (index) => _ListItem(index: index));
    
    return Column(
      children: [
        _BuildTimeIndicator(buildTime: _buildTime),
        Expanded(
          child: ListView(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _AfterListView extends StatefulWidget {
  const _AfterListView();

  @override
  State<_AfterListView> createState() => _AfterListViewState();
}

class _AfterListViewState extends State<_AfterListView> {
  final Stopwatch _stopwatch = Stopwatch();
  Duration? _buildTime;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stopwatch.stop();
      if (mounted) {
        setState(() {
          _buildTime = _stopwatch.elapsed;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BuildTimeIndicator(buildTime: _buildTime),
        Expanded(
          child: ListView.builder(
            itemCount: 5000,
            itemExtent: 60.0,
            cacheExtent: 100.0,
            itemBuilder: (context, index) {
              return _ListItem(index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _BuildTimeIndicator extends StatelessWidget {
  final Duration? buildTime;
  const _BuildTimeIndicator({required this.buildTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8.0),
      child: Text(
        buildTime == null 
            ? 'Measuring build time...' 
            : 'Initial Build Time: ${buildTime!.inMilliseconds} ms',
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final int index;
  const _ListItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          CircleAvatar(child: Text('${index % 10}')),
          const SizedBox(width: 16),
          Text('Item number $index'),
        ],
      ),
    );
  }
}
