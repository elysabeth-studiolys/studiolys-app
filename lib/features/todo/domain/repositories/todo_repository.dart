import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/todo_item.dart';

abstract class TodoRepository {
  Future<Either<Failure, void>> saveTodo(TodoItem todo);
  Future<Either<Failure, List<TodoItem>>> getAllTodos();
  Future<Either<Failure, List<TodoItem>>> getTodosByWeek(DateTime weekStart);
  Future<Either<Failure, void>> toggleTodo(String id);
  Future<Either<Failure, void>> deleteTodo(String id);
}