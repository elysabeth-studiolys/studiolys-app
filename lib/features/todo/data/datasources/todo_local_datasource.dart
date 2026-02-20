import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo_item_model.dart';

class TodoLocalDataSource {
  static const String boxName = 'todos';
  late Box<TodoItemModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<TodoItemModel>(boxName);
  }

  Future<void> saveTodo(TodoItemModel todo) async {
    await _box.put(todo.id, todo);
  }

  List<TodoItemModel> getAllTodos() {
    return _box.values.toList();
  }

  List<TodoItemModel> getTodosByWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    return _box.values.where((todo) {
      return todo.dueDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
             todo.dueDate.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
  }

  Future<void> toggleTodo(String id) async {
    final todo = _box.get(id);
    if (todo != null) {
      final updated = TodoItemModel(
        id: todo.id,
        title: todo.title,
        dueDate: todo.dueDate,
        isCompleted: !todo.isCompleted,
        createdAt: todo.createdAt,
      );
      await _box.put(id, updated);
    }
  }

  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
  }
}