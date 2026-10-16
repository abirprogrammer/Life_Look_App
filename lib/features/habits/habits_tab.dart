import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../models/app_models.dart';
import '../../providers/app_providers.dart';

class HabitsTab extends ConsumerStatefulWidget {
  const HabitsTab({super.key});

  @override
  ConsumerState<HabitsTab> createState() => _HabitsTabState();
}

class _HabitsTabState extends ConsumerState<HabitsTab> {
  final _titleController = TextEditingController();
  String _category = 'Wellness';

  void _showAddHabitSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Create New Habit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Habit Title (e.g., Read 20 pages)', prefixIcon: Icon(Icons.bolt, color: AppTheme.primaryPurple)),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category_outlined, color: AppTheme.primaryPurple)),
              items: ['Wellness', 'Mindfulness', 'Career', 'Fitness', 'Productivity']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _category = val ?? 'Wellness'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final newHabit = HabitModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text.trim(),
                    streakCount: 0,
                    completedDates: [],
                    category: _category,
                  );
                  ref.read(habitsProvider.notifier).addHabit(newHabit);
                  _titleController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New habit created successfully! 🎯')));
                }
              },
              child: const Text('Save Habit'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitsProvider);
    final totalStreaks = habits.fold(0, (sum, h) => sum + h.streakCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker & Streaks', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department_outlined, size: 64, color: AppTheme.primaryPurple),
                  const SizedBox(height: 16),
                  const Text('No active habits yet!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Tap + below to build your daily streak.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: _showAddHabitSheet, child: const Text('Add Habit')),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryPurple, AppTheme.secondaryPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Active Habits', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text('${habits.length} Tracked', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
                            const SizedBox(width: 8),
                            Text('$totalStreaks Streaks', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Daily Check-Ins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...habits.map((habit) => Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.task_alt, color: AppTheme.primaryPurple),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(habit.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(habit.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple)),
                                      backgroundColor: AppTheme.primaryPurple.withOpacity(0.1),
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      side: BorderSide.none,
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                                    const SizedBox(width: 2),
                                    Text('${habit.streakCount} days', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.orange)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(habitsProvider.notifier).incrementStreak(habit.id);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Streak checked in for ${habit.title}! 🔥')));
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(80, 38),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Check In', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddHabitSheet,
        backgroundColor: AppTheme.primaryPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Habit', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
