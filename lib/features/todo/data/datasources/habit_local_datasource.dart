import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';
import '../models/habit_model.dart';
import '../models/habit_completion_model.dart';

abstract class HabitLocalDataSource {
  Future<void> createHabit(HabitModel model);
  Future<void> updateHabit(HabitModel model);
  Future<void> deleteHabit(String id);
  Future<List<HabitModel>> getHabits();
  Future<void> saveHabitCompletion(HabitCompletionModel model);
  Future<List<HabitCompletionModel>> getHabitCompletions(
    String habitId,
    DateTime weekStart,
  );
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final HiveService hiveService;

  HabitLocalDataSourceImpl(this.hiveService);

  @override
  Future<void> createHabit(HabitModel model) async {
    try {
      final box = await hiveService.habitBox;
      await box.put(model.id, model);
    } catch (e) {
      throw StorageException('Erreur lors de la création de l\'habitude: $e');
    }
  }

  @override
  Future<void> updateHabit(HabitModel model) async {
    try {
      final box = await hiveService.habitBox;
      await box.put(model.id, model);
    } catch (e) {
      throw StorageException('Erreur lors de la mise à jour de l\'habitude: $e');
    }
  }

  @override
  Future<void> deleteHabit(String id) async {
    try {
      final box = await hiveService.habitBox;
      await box.delete(id);
      
      final completionBox = await hiveService.habitCompletionBox;
      final completionsToDelete = completionBox.values
          .whereType<HabitCompletionModel>()
          .where((c) => c.habitId == id)
          .map((c) => c.id)
          .toList();
      
      for (var completionId in completionsToDelete) {
        await completionBox.delete(completionId);
      }
    } catch (e) {
      throw StorageException('Erreur lors de la suppression de l\'habitude: $e');
    }
  }

  @override
  Future<List<HabitModel>> getHabits() async {
    try {
      final box = await hiveService.habitBox;
      final habits = box.values.whereType<HabitModel>().toList();
      habits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return habits;
    } catch (e) {
      throw StorageException('Erreur lors de la récupération des habitudes: $e');
    }
  }

  @override
  Future<void> saveHabitCompletion(HabitCompletionModel model) async {
    try {
      final box = await hiveService.habitCompletionBox;
      await box.put(model.id, model);
    } catch (e) {
      throw StorageException('Erreur lors de la sauvegarde de la complétion: $e');
    }
  }

  @override
  Future<List<HabitCompletionModel>> getHabitCompletions(
    String habitId,
    DateTime weekStart,
  ) async {
    try {
      final box = await hiveService.habitCompletionBox;
      final weekEnd = weekStart.add(const Duration(days: 7));
      
      final completions = box.values
          .whereType<HabitCompletionModel>()
          .where((c) =>
              c.habitId == habitId &&
              c.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
              c.date.isBefore(weekEnd))
          .toList();
      
      return completions;
    } catch (e) {
      throw StorageException(
          'Erreur lors de la récupération des complétions: $e');
    }
  }
}