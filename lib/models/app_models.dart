class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final int xp;
  final int level;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.xp = 0,
    this.level = 1,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'xp': xp,
        'level': level,
      };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        uid: map['uid'] ?? '',
        email: map['email'] ?? '',
        displayName: map['displayName'] ?? 'User',
        photoUrl: map['photoUrl'],
        xp: map['xp'] ?? 0,
        level: map['level'] ?? 1,
      );
}

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String category;
  final String priority; // Low, Medium, High

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.category = 'General',
    this.priority = 'Medium',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'isCompleted': isCompleted,
        'category': category,
        'priority': priority,
      };

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : DateTime.now(),
        isCompleted: map['isCompleted'] ?? false,
        category: map['category'] ?? 'General',
        priority: map['priority'] ?? 'Medium',
      );

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? category,
    String? priority,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }
}

class HabitModel {
  final String id;
  final String title;
  final int streakCount;
  final List<String> completedDates; // yyyy-MM-dd format
  final String category;

  HabitModel({
    required this.id,
    required this.title,
    this.streakCount = 0,
    required this.completedDates,
    this.category = 'Wellness',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'streakCount': streakCount,
        'completedDates': completedDates,
        'category': category,
      };

  factory HabitModel.fromMap(Map<String, dynamic> map) => HabitModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        streakCount: map['streakCount'] ?? 0,
        completedDates: List<String>.from(map['completedDates'] ?? []),
        category: map['category'] ?? 'Wellness',
      );
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'] ?? '',
        text: map['text'] ?? '',
        isUser: map['isUser'] ?? false,
        timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : DateTime.now(),
      );
}

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final int participantsCount;
  final bool isJoined;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    this.participantsCount = 120,
    this.isJoined = false,
  });
}
