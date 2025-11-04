class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime? deadline;
  final DateTime createdAt;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    required this.createdAt,
    this.isCompleted = false,
  });

  // Convert Task to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'deadline': deadline?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'isCompleted': isCompleted,
  };

  // Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    createdAt: DateTime.parse(json['createdAt']),
    isCompleted: json['isCompleted'] ?? false,
  );
}