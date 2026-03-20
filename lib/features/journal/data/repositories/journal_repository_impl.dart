import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_local_datasource.dart';
import '../models/journal_entry_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource localDataSource;

  JournalRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveEntry(JournalEntry entry) async {
    try {
      final model = JournalEntryModel.fromEntity(entry);
      await localDataSource.saveEntry(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntry>>> getAllEntries() async {
    try {
      final models = localDataSource.getAllEntries();
      final entries = models.map((m) => m.toEntity()).toList();
      // Trier par date (plus récent en premier)
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(entries);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JournalEntry?>> getEntry(String id) async {
    try {
      final model = localDataSource.getEntry(id);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(String id) async {
    try {
      await localDataSource.deleteEntry(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}