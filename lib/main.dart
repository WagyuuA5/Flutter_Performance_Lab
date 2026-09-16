import 'package:flutter/material.dart';
import 'cases/rebuild/case_rebuild.dart';
import 'cases/listview/case_listview.dart';
import 'cases/image/case_image.dart';
import 'cases/build_method/case_build_method.dart';
import 'cases/expensive_widgets/case_expensive_widgets.dart';

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
          ListTile(
            title: const Text('Case 1: Excessive Rebuilds'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CaseRebuildScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Case 2: Expensive ListView'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CaseListViewScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Case 3: Unoptimized Images'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CaseImageScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Case 4: Heavy Build Method'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CaseBuildMethodScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Case 5: Expensive Widgets'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CaseExpensiveWidgetsScreen()),
              );
            },
          ),
          ListTile(title: const Text('Case 6: Missing Debounce'), onTap: () {}),
          ListTile(title: const Text('Case 7: Animation Jank'), onTap: () {}),
        ],
      ),
    );
  }
}
