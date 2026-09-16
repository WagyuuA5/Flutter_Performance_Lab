import 'dart:async';
import 'package:flutter/material.dart';

class CaseDebounceScreen extends StatelessWidget {
  const CaseDebounceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Case 6: Missing Debounce'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Before (Every Key)'),
              Tab(text: 'After (Debounced)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BeforeDebounce(),
            _AfterDebounce(),
          ],
        ),
      ),
    );
  }
}

class _BeforeDebounce extends StatefulWidget {
  const _BeforeDebounce();

  @override
  State<_BeforeDebounce> createState() => _BeforeDebounceState();
}

class _BeforeDebounceState extends State<_BeforeDebounce> {
  int _apiCallCount = 0;
  String _lastQuery = '';
  final TextEditingController _controller = TextEditingController();

  void _onSearchChanged(String query) {
    // BAD: Called immediately on every single keystroke
    _performFakeApiCall(query);
  }

  void _performFakeApiCall(String query) {
    setState(() {
      _apiCallCount++;
      _lastQuery = query;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search (No Debounce)',
              border: OutlineInputBorder(),
              hintText: 'Type fast...',
            ),
          ),
          const SizedBox(height: 32),
          _ApiStatsWidget(callCount: _apiCallCount, lastQuery: _lastQuery),
        ],
      ),
    );
  }
}

class _AfterDebounce extends StatefulWidget {
  const _AfterDebounce();

  @override
  State<_AfterDebounce> createState() => _AfterDebounceState();
}

class _AfterDebounceState extends State<_AfterDebounce> {
  int _apiCallCount = 0;
  String _lastQuery = '';
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  void _onSearchChanged(String query) {
    // GOOD: Cancel previous timer if the user types again within 300ms
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performFakeApiCall(query);
    });
  }

  void _performFakeApiCall(String query) {
    setState(() {
      _apiCallCount++;
      _lastQuery = query;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search (300ms Debounce)',
              border: OutlineInputBorder(),
              hintText: 'Type fast...',
            ),
          ),
          const SizedBox(height: 32),
          _ApiStatsWidget(callCount: _apiCallCount, lastQuery: _lastQuery),
        ],
      ),
    );
  }
}

class _ApiStatsWidget extends StatelessWidget {
  final int callCount;
  final String lastQuery;

  const _ApiStatsWidget({required this.callCount, required this.lastQuery});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          const Text('Total "API" Calls Made:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            '$callCount', 
            style: TextStyle(
              fontSize: 48, 
              fontWeight: FontWeight.bold,
              color: callCount > 10 ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Text('Last searched query: "$lastQuery"'),
        ],
      ),
    );
  }
}
