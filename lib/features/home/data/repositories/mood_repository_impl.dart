import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/mood_local_datasource.dart';
import '../models/mood_entry_model.dart';

/// Implémentation du repository pour les mood entries
class MoodRepositoryImpl implements MoodRepository {
  final MoodLocalDataSource localDataSource;

  MoodRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveMood(MoodEntry entry) async {
    try {
      final model = MoodEntryModel.fromEntity(entry);
      await localDataSource.saveMood(model);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, MoodEntry?>> getDailyMood(DateTime date) async {
    try {
      final model = await localDataSource.getDailyMood(date);
      return Right(model?.toEntity());
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MoodEntry>>> getMoodHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final models = await localDataSource.getMoodHistory(
        startDate: startDate,
        endDate: endDate,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MoodEntry>>> getWeeklyMoods(
      DateTime startOfWeek) async {
    try {
      final models = await localDataSource.getWeeklyMoods(startOfWeek);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMood(String id) async {
    try {
      await localDataSource.deleteMood(id);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateMood(MoodEntry entry) async {
    try {
      final model = MoodEntryModel.fromEntity(entry);
      await localDataSource.updateMood(model);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure('Erreur inattendue: $e'));
    }
  }
}
