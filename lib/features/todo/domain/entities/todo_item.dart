class TodoItem {
  final String id;
  final String title;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime createdAt;

  const TodoItem({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.isCompleted,
    required this.createdAt,
  });

  TodoItem copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}