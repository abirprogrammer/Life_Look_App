import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'dashboard/dashboard_tab.dart';
import 'tasks/tasks_tab.dart';
import 'habits/habits_tab.dart';
import 'assistant/ai_assistant_tab.dart';
import 'social/social_tab.dart';
import 'settings/settings_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const DashboardTab(),
    const TasksTab(),
    const HabitsTab(),
    const AiAssistantTab(),
    const SocialTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        indicatorColor: AppTheme.primaryPurple.withOpacity(0.2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryPurple), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.task_outlined), selectedIcon: Icon(Icons.task, color: AppTheme.primaryPurple), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.local_fire_department_outlined), selectedIcon: Icon(Icons.local_fire_department, color: AppTheme.primaryPurple), label: 'Habits'),
          NavigationDestination(icon: Icon(Icons.psychology_outlined), selectedIcon: Icon(Icons.psychology, color: AppTheme.primaryPurple), label: 'AI Coach'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people, color: AppTheme.primaryPurple), label: 'Social'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings, color: AppTheme.primaryPurple), label: 'Settings'),
        ],
      ),
    );
  }
}
