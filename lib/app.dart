import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_app/features/journal/presentation/screens/journal_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/todo/presentation/screens/todo_screen.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart';
import 'features/navigation/presentation/providers/navigation_provider.dart';
import 'features/navigation/presentation/widgets/custom_bottom_nav_bar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),
          StatisticsScreen(),
          _PlaceholderScreen(title: 'Add'),
          TodoScreen(), 
          JournalScreen(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$title - Coming Soon',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}