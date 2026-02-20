import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/mood_entry.dart';


abstract class MoodRepository {

  Future<Either<Failure, void>> saveMood(MoodEntry entry);

  Future<Either<Failure, MoodEntry?>> getDailyMood(DateTime date);

  Future<Either<Failure, List<MoodEntry>>> getMoodHistory({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, List<MoodEntry>>> getWeeklyMoods(DateTime startOfWeek);

  Future<Either<Failure, void>> deleteMood(String id);

  Future<Either<Failure, void>> updateMood(MoodEntry entry);
}
