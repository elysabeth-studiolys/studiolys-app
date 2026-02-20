import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/todo_local_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/entities/todo_item.dart';
import '../../domain/repositories/todo_repository.dart';

final selectedTodoWeekProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  final weekday = now.weekday;
  return now.subtract(Duration(days: weekday - 1));
});

final todoLocalDataSourceProvider = Provider<TodoLocalDataSource>((ref) {
  throw UnimplementedError('Use todoLocalDataSourceInitProvider instead');
});

final todoLocalDataSourceInitProvider = FutureProvider<TodoLocalDataSource>((ref) async {
  final dataSource = TodoLocalDataSource();
  await dataSource.init();
  return dataSource;
});

final todoRepositoryProvider = FutureProvider<TodoRepository>((ref) async {
  final dataSource = await ref.watch(todoLocalDataSourceInitProvider.future);
  return TodoRepositoryImpl(dataSource);
});

final weeklyTodosProvider = FutureProvider.family<List<TodoItem>, DateTime>(
  (ref, weekStart) async {
    final repository = await ref.watch(todoRepositoryProvider.future);
    final result = await repository.getTodosByWeek(weekStart);
    return result.fold(
      (failure) => [],
      (todos) => todos,
    );
  },
);

final allTodosProvider = FutureProvider<List<TodoItem>>((ref) async {
  final repository = await ref.watch(todoRepositoryProvider.future);
  final result = await repository.getAllTodos();
  return result.fold(
    (failure) => [],
    (todos) => todos,
  );
});

final todoNotifierProvider = StateNotifierProvider<TodoNotifier, AsyncValue<void>>(
  (ref) => TodoNotifier(ref),
);

class TodoNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  TodoNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<bool> addTodo(String title, DateTime dueDate) async {
    state = const AsyncValue.loading();

    try {
      final todo = TodoItem(
        id: const Uuid().v4(),
        title: title,
        dueDate: dueDate,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final repository = await ref.read(todoRepositoryProvider.future);
      final result = await repository.saveTodo(todo);

      return result.fold(
        (failure) {
          state = AsyncValue.error(failure, StackTrace.current);
          return false;
        },
        (_) {
          state = const AsyncValue.data(null);
          ref.invalidate(weeklyTodosProvider);
          ref.invalidate(allTodosProvider);
          return true;
        },
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<void> toggleTodo(String id) async {
    try {
      final repository = await ref.read(todoRepositoryProvider.future);
      await repository.toggleTodo(id);
      ref.invalidate(weeklyTodosProvider);
      ref.invalidate(allTodosProvider);
    } catch (e) {
      // Gérer l'erreur
      print('Error toggling todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final repository = await ref.read(todoRepositoryProvider.future);
      await repository.deleteTodo(id);
      ref.invalidate(weeklyTodosProvider);
      ref.invalidate(allTodosProvider);
    } catch (e) {
      // Gérer l'erreur
      print('Error deleting todo: $e');
    }
  }
}