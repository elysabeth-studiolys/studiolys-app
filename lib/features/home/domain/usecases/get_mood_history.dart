import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/mood_entry.dart';
import '../repositories/mood_repository.dart';

class GetMoodHistory {
  final MoodRepository repository;

  GetMoodHistory(this.repository);

  Future<Either<Failure, List<MoodEntry>>> call({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getMoodHistory(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
