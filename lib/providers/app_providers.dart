import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/services/gemini_service.dart';
import '../models/app_models.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());
final geminiServiceProvider = Provider<GeminiService>((ref) => GeminiService());

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final themeModeProvider = StateProvider<bool>((ref) => false); // false = light, true = dark

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskModel>>((ref) {
  return TasksNotifier(ref.watch(firestoreServiceProvider));
});

class TasksNotifier extends StateNotifier<List<TaskModel>> {
  final FirestoreService _firestoreService;
  TasksNotifier(this._firestoreService) : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = await _firestoreService.getTasks('default_user');
  }

  Future<void> addTask(TaskModel task) async {
    state = [...state, task];
    await _firestoreService.saveTask('default_user', task);
  }

  Future<void> toggleTask(String id) async {
    state = state.map((t) => t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t).toList();
    final task = state.firstWhere((t) => t.id == id);
    await _firestoreService.saveTask('default_user', task);
  }

  Future<void> deleteTask(String id) async {
    state = state.where((t) => t.id != id).toList();
    await _firestoreService.deleteTask('default_user', id);
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<HabitModel>>((ref) {
  return HabitsNotifier(ref.watch(firestoreServiceProvider));
});

class HabitsNotifier extends StateNotifier<List<HabitModel>> {
  final FirestoreService _firestoreService;
  HabitsNotifier(this._firestoreService) : super([]) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    state = await _firestoreService.getHabits('default_user');
  }

  Future<void> addHabit(HabitModel habit) async {
    state = [...state, habit];
    await _firestoreService.saveHabit('default_user', habit);
  }

  Future<void> incrementStreak(String id) async {
    state = state.map((h) {
      if (h.id == id) {
        return HabitModel(
          id: h.id,
          title: h.title,
          streakCount: h.streakCount + 1,
          completedDates: [...h.completedDates, DateTime.now().toIso8601String()],
          category: h.category,
        );
      }
      return h;
    }).toList();
  }
}

final chatMessagesProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(ref.watch(geminiServiceProvider));
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final GeminiService _geminiService;
  ChatNotifier(this._geminiService) : super([
    ChatMessage(id: '0', text: 'Hello! I am your LifeLoop AI Assistant. How can I help you optimize your day, plan routines, or boost your productivity?', isUser: false, timestamp: DateTime.now())
  ]);

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final userMsg = ChatMessage(id: DateTime.now().millisecondsSinceEpoch.toString(), text: text, isUser: true, timestamp: DateTime.now());
    state = [...state, userMsg];

    final replyText = await _geminiService.getAssistantResponse(text);
    final aiMsg = ChatMessage(id: (DateTime.now().millisecondsSinceEpoch + 1).toString(), text: replyText, isUser: false, timestamp: DateTime.now());
    state = [...state, aiMsg];
  }
}
