class ProjectTask {
  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  ProjectTask({
    required this.id,
    required this.title,
    this.isDone = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ProjectTask copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return ProjectTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  ProjectTask toggleDone() {
    return copyWith(isDone: !isDone);
  }
}