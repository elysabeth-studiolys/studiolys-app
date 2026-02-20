import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/todo_item.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../data/datasources/todo_local_datasource.dart';
import '../../domain/entities/todo_item.dart';
import '../models/todo_item_model.dart';  


class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveTodo(TodoItem todo) async {
    try {
      print('Saving todo: ${todo.title}, due on ${todo.dueDate}');
      final model = TodoItemModel.fromEntity(todo);
      await localDataSource.saveTodo(model);
      print('Todo saved successfully.');
      return const Right(null);
    } catch (e) {
      print('Error saving todo: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TodoItem>>> getAllTodos() async {
    try {
      final models = localDataSource.getAllTodos();
      final todos = models.map((m) => m.toEntity()).toList();

      todos.sort((a, b) {
        final dateCompare = a.dueDate.compareTo(b.dueDate);
        if (dateCompare != 0) return dateCompare;
        return a.isCompleted == b.isCompleted ? 0 : (a.isCompleted ? 1 : -1);
      });
      return Right(todos);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TodoItem>>> getTodosByWeek(DateTime weekStart) async {
    try {
      final models = localDataSource.getTodosByWeek(weekStart);
      final todos = models.map((m) => m.toEntity()).toList();
      todos.sort((a, b) {
        final dateCompare = a.dueDate.compareTo(b.dueDate);
        if (dateCompare != 0) return dateCompare;
        return a.isCompleted == b.isCompleted ? 0 : (a.isCompleted ? 1 : -1);
      });
      return Right(todos);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleTodo(String id) async {
    try {
      await localDataSource.toggleTodo(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {
    try {
      await localDataSource.deleteTodo(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}