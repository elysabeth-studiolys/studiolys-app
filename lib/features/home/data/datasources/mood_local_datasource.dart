import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';
import '../models/mood_entry_model.dart';

abstract class MoodLocalDataSource {
  Future<void> saveMood(MoodEntryModel model);
  Future<MoodEntryModel?> getDailyMood(DateTime date);
  Future<List<MoodEntryModel>> getMoodHistory({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<MoodEntryModel>> getWeeklyMoods(DateTime startOfWeek);
  Future<void> deleteMood(String id);
  Future<void> updateMood(MoodEntryModel model);
}

class MoodLocalDataSourceImpl implements MoodLocalDataSource {
  final HiveService hiveService;

  MoodLocalDataSourceImpl(this.hiveService);

  @override
  Future<void> saveMood(MoodEntryModel model) async {
    try {
      final box = await hiveService.moodBox;
      await box.put(model.id, model);
    } catch (e) {
      throw StorageException('Erreur lors de la sauvegarde de l\'humeur: $e');
    }
  }

  @override
  Future<MoodEntryModel?> getDailyMood(DateTime date) async {
    try {
      final box = await hiveService.moodBox;
      final dateOnly = date.dateOnly;


      for (var entry in box.values) {
        if (entry is MoodEntryModel) {
          if (entry.date.dateOnly.isAtSameMomentAs(dateOnly)) {
            return entry;
          }
        }
      }

      return null;
    } catch (e) {
      throw StorageException('Erreur lors de la récupération de l\'humeur: $e');
    }
  }

  @override
  Future<List<MoodEntryModel>> getMoodHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final box = await hiveService.moodBox;
      final entries = box.values.whereType<MoodEntryModel>().toList();

      if (startDate != null || endDate != null) {
        return entries.where((entry) {
          final entryDate = entry.date.dateOnly;
          final matchesStart =
              startDate == null || entryDate.isAfter(startDate.dateOnly) || entryDate.isAtSameMomentAs(startDate.dateOnly);
          final matchesEnd =
              endDate == null || entryDate.isBefore(endDate.dateOnly) || entryDate.isAtSameMomentAs(endDate.dateOnly);
          return matchesStart && matchesEnd;
        }).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      }

      entries.sort((a, b) => b.date.compareTo(a.date));
      return entries;
    } catch (e) {
      throw StorageException('Erreur lors de la récupération de l\'historique: $e');
    }
  }

  @override
  Future<List<MoodEntryModel>> getWeeklyMoods(DateTime startOfWeek) async {
    try {
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      return await getMoodHistory(
        startDate: startOfWeek,
        endDate: endOfWeek,
      );
    } catch (e) {
      throw StorageException(
          'Erreur lors de la récupération des humeurs de la semaine: $e');
    }
  }

  @override
  Future<void> deleteMood(String id) async {
    try {
      final box = await hiveService.moodBox;
      await box.delete(id);
    } catch (e) {
      throw StorageException('Erreur lors de la suppression de l\'humeur: $e');
    }
  }

  @override
  Future<void> updateMood(MoodEntryModel model) async {
    try {
      final box = await hiveService.moodBox;
      await box.put(model.id, model);
    } catch (e) {
      throw StorageException('Erreur lors de la mise à jour de l\'humeur: $e');
    }
  }
}
