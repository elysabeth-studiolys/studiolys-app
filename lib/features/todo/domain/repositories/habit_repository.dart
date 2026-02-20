import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit.dart';
import '../entities/habit_completion.dart';

abstract class HabitRepository {
  Future<Either<Failure, void>> createHabit(Habit habit);
  Future<Either<Failure, void>> updateHabit(Habit habit);
  Future<Either<Failure, void>> deleteHabit(String id);
  Future<Either<Failure, List<Habit>>> getHabits();
  Future<Either<Failure, void>> toggleHabitCompletion(
    String habitId,
    DateTime date,
  );
  Future<Either<Failure, List<HabitCompletion>>> getHabitCompletions(
    String habitId,
    DateTime weekStart,
  );
}