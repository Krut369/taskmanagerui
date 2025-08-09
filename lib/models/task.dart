enum TaskStatus { notStarted, started, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final String assignee;
  TaskStatus status;
  DateTime startDate;
  final bool isHighPriority;
  final TaskType type;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignee,
    required this.status,
    required this.startDate,
    this.isHighPriority = false,
    required this.type,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? assignee,
    TaskStatus? status,
    DateTime? startDate,
    bool? isHighPriority,
    TaskType? type,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignee: assignee ?? this.assignee,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      isHighPriority: isHighPriority ?? this.isHighPriority,
      type: type ?? this.type,
    );
  }
}

enum TaskType { order, entity, enquiry } 