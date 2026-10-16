import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../models/app_models.dart';
import '../../providers/app_providers.dart';

class TasksTab extends ConsumerStatefulWidget {
  const TasksTab({super.key});

  @override
  ConsumerState<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends ConsumerState<TasksTab> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _category = 'General';
  String _priority = 'Medium';

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Add New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Task Title')),
            const SizedBox(height: 12),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final newTask = TaskModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text.trim(),
                    description: _descController.text.trim(),
                    dueDate: DateTime.now(),
                    category: _category,
                    priority: _priority,
                  );
                  ref.read(tasksProvider.notifier).addTask(newTask);
                  _titleController.clear();
                  _descController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Task'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Planner', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add one!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  onDismissed: (_) => ref.read(tasksProvider.notifier).deleteTask(task.id),
                  background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => ref.read(tasksProvider.notifier).toggleTask(task.id),
                        activeColor: AppTheme.primaryPurple,
                      ),
                      title: Text(task.title, style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null, fontWeight: FontWeight.w600)),
                      subtitle: Text(task.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        onPressed: () => ref.read(tasksProvider.notifier).deleteTask(task.id),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: AppTheme.primaryPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
