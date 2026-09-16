import 'package:flutter/material.dart';

void main() {
  runApp(const PerformanceLabApp());
}

class PerformanceLabApp extends StatelessWidget {
  const PerformanceLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Performance Lab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Performance Lab'),
      ),
      body: ListView(
        children: [
          ListTile(title: const Text('Case 1: Excessive Rebuilds'), onTap: () {}),
          ListTile(title: const Text('Case 2: Expensive ListView'), onTap: () {}),
          ListTile(title: const Text('Case 3: Unoptimized Images'), onTap: () {}),
          ListTile(title: const Text('Case 4: Heavy Build Method'), onTap: () {}),
          ListTile(title: const Text('Case 5: Expensive Widgets'), onTap: () {}),
          ListTile(title: const Text('Case 6: Missing Debounce'), onTap: () {}),
          ListTile(title: const Text('Case 7: Animation Jank'), onTap: () {}),
        ],
      ),
    );
  }
}

