import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Tasks
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final snapshot = await _db.collection('users').doc(userId).collection('tasks').get();
      return snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
    } catch (_) {
      // Return default sample tasks if offline or uninitialized
      return [
        TaskModel(id: '1', title: 'Complete Morning Workout', description: '30 mins cardio & stretching', dueDate: DateTime.now(), category: 'Health', priority: 'High'),
        TaskModel(id: '2', title: 'Review Weekly Goals', description: 'Check progress on quarterly OKRs', dueDate: DateTime.now(), category: 'Work', priority: 'Medium'),
        TaskModel(id: '3', title: 'Read 20 pages of a book', description: 'Atomic Habits chapter 4', dueDate: DateTime.now(), category: 'Personal', priority: 'Low'),
      ];
    }
  }

  Future<void> saveTask(String userId, TaskModel task) async {
    try {
      await _db.collection('users').doc(userId).collection('tasks').doc(task.id).set(task.toMap());
    } catch (_) {}
  }

  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _db.collection('users').doc(userId).collection('tasks').doc(taskId).delete();
    } catch (_) {}
  }

  // Habits
  Future<List<HabitModel>> getHabits(String userId) async {
    try {
      final snapshot = await _db.collection('users').doc(userId).collection('habits').get();
      return snapshot.docs.map((doc) => HabitModel.fromMap(doc.data())).toList();
    } catch (_) {
      return [
        HabitModel(id: 'h1', title: 'Drink 2L Water', streakCount: 5, completedDates: [], category: 'Health'),
        HabitModel(id: 'h2', title: 'Meditate 10 mins', streakCount: 3, completedDates: [], category: 'Mindfulness'),
        HabitModel(id: 'h3', title: 'Code for 1 hour', streakCount: 12, completedDates: [], category: 'Career'),
      ];
    }
  }

  Future<void> saveHabit(String userId, HabitModel habit) async {
    try {
      await _db.collection('users').doc(userId).collection('habits').doc(habit.id).set(habit.toMap());
    } catch (_) {}
  }
}
