import 'project_task.dart';

enum ProjectPriority {
  low,
  medium,
  high,
  urgent;

  String get label {
    switch (this) {
      case ProjectPriority.low:
        return 'Faible';
      case ProjectPriority.medium:
        return 'Moyenne';
      case ProjectPriority.high:
        return 'Haute';
      case ProjectPriority.urgent:
        return 'Urgente';
    }
  }
}

class Project {
  final String id;
  final String title;
  final String category;
  final String? description;
  final DateTime? dueDate;
  final bool isDone;
  final DateTime createdAt;
  final ProjectPriority priority;
  final List<ProjectTask> tasks;

  Project({
    required this.id,
    required this.title,
    required this.category,
    this.description,
    this.dueDate,
    this.isDone = false,
    DateTime? createdAt,
    this.priority = ProjectPriority.medium,
    List<ProjectTask>? tasks,
  }) : createdAt = createdAt ?? DateTime.now(),
       tasks = tasks ?? [];

  Project copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    DateTime? dueDate,
    bool? isDone,
    DateTime? createdAt,
    ProjectPriority? priority,
    List<ProjectTask>? tasks,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      tasks: tasks ?? this.tasks,
    );
  }

  Project toggleDone() {
    return copyWith(isDone: !isDone);
  }

  bool get isOverdue {
    if (dueDate == null || isDone) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  int get daysUntilDue {
    if (dueDate == null) return 0;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  // Statistiques des tâches
  int get totalTasks => tasks.length;
  
  int get completedTasks => tasks.where((t) => t.isDone).length;
  
  int get remainingTasks => tasks.where((t) => !t.isDone).length;
  
  double get completionPercentage {
    if (tasks.isEmpty) return 0;
    return (completedTasks / totalTasks) * 100;
  }

  bool get hasAllTasksCompleted {
    if (tasks.isEmpty) return false;
    return tasks.every((t) => t.isDone);
  }
}