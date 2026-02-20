import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/mood_entry.dart';
import '../repositories/mood_repository.dart';

class SaveMood {
  final MoodRepository repository;

  SaveMood(this.repository);

  Future<Either<Failure, void>> call(MoodEntry entry) async {
    return await repository.saveMood(entry);
  }
}
