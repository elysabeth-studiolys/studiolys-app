import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_completion.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_local_datasource.dart';
import '../models/habit_model.dart';
import '../models/habit_completion_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> createHabit(Habit habit) async {
    try {
      final model = HabitModel.fromEntity(habit);
      await localDataSource.createHabit(model);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateHabit(Habit habit) async {
    try {
      final model = HabitModel.fromEntity(habit);
      await localDataSource.updateHabit(model);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHabit(String id) async {
    try {
      await localDataSource.deleteHabit(id);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Habit>>> getHabits() async {
    try {
      final models = await localDataSource.getHabits();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleHabitCompletion(
    String habitId,
    DateTime date,
  ) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      
      final weekday = dateOnly.weekday;
      final weekStart = dateOnly.subtract(Duration(days: weekday - 1));
      
      final completions = await localDataSource.getHabitCompletions(
        habitId,
        weekStart,
      );
      
      HabitCompletionModel? existingCompletion;
      try {
        existingCompletion = completions.firstWhere(
          (c) {
            final cDate = DateTime(c.date.year, c.date.month, c.date.day);
            return cDate.year == dateOnly.year &&
                cDate.month == dateOnly.month &&
                cDate.day == dateOnly.day;
          },
        );
      } catch (e) {
        existingCompletion = null;
      }
      
      final updatedCompletion = existingCompletion == null
          ? HabitCompletionModel(
              id: '${habitId}_${dateOnly.toIso8601String()}',
              habitId: habitId,
              date: dateOnly,
              isCompleted: true,
            )
          : existingCompletion.copyWith(
              isCompleted: !existingCompletion.isCompleted,
            );
      
      await localDataSource.saveHabitCompletion(updatedCompletion);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, List<HabitCompletion>>> getHabitCompletions(
    String habitId,
    DateTime weekStart,
  ) async {
    try {
      final models = await localDataSource.getHabitCompletions(
        habitId,
        weekStart,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }
}