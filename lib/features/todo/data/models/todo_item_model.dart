import 'package:hive/hive.dart';
import '../../domain/entities/todo_item.dart';

part 'todo_item_model.g.dart';

@HiveType(typeId: 5)
class TodoItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime dueDate;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime createdAt;

  TodoItemModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.isCompleted,
    required this.createdAt,
  });

  factory TodoItemModel.fromEntity(TodoItem entity) {
    return TodoItemModel(
      id: entity.id,
      title: entity.title,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
    );
  }

  TodoItem toEntity() {
    return TodoItem(
      id: id,
      title: title,
      dueDate: dueDate,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }
}