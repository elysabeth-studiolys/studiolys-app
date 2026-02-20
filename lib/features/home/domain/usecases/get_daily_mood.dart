import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/mood_entry.dart';
import '../repositories/mood_repository.dart';

class GetDailyMood {
  final MoodRepository repository;

  GetDailyMood(this.repository);

  Future<Either<Failure, MoodEntry?>> call(DateTime date) async {
    return await repository.getDailyMood(date);
  }
}
