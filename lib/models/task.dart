enum Priority { urgent, high, medium, low }

class Task {
  String id;
  String title;
  bool isCompleted;
  Priority priority;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.priority,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    Priority? priority,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'priority': priority.index,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'],
        priority: Priority.values[json['priority']],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
