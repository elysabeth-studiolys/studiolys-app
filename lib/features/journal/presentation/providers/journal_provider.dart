import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/journal_local_datasource.dart';
import '../../data/repositories/journal_repository_impl.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../../../quotes/presentation/providers/quote_provider.dart';
import '../../../statistics/presentation/providers/metric_note_provider.dart';

// Provider pour le datasource
final journalLocalDataSourceProvider = FutureProvider<JournalLocalDataSource>((ref) async {
  final dataSource = JournalLocalDataSource();
  await dataSource.init();
  return dataSource;
});

// Provider pour le repository
final journalRepositoryProvider = FutureProvider<JournalRepository>((ref) async {
  final dataSource = await ref.watch(journalLocalDataSourceProvider.future);
  return JournalRepositoryImpl(dataSource);
});

// ← NOUVEAU: Provider pour le mois sélectionné
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1); // Premier jour du mois
});

// Provider pour toutes les entrées du journal
final allJournalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final repository = await ref.watch(journalRepositoryProvider.future);
  final result = await repository.getAllEntries();
  return result.fold(
    (failure) => [],
    (entries) => entries,
  );
});

// ← NOUVEAU: Provider pour les entrées du mois sélectionné
final monthJournalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final allEntries = await ref.watch(allJournalEntriesProvider.future);
  
  return allEntries.where((entry) {
    return entry.createdAt.year == selectedMonth.year &&
           entry.createdAt.month == selectedMonth.month;
  }).toList();
});

// ← NOUVEAU: Provider pour les citations favorites du mois sélectionné
final monthFavoriteQuotesProvider = FutureProvider<List>((ref) async {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final allQuotes = await ref.watch(favoriteQuotesProvider.future);
  
  // Note: Si FavoriteQuoteModel a un addedAt, filtrer par mois
  // Sinon, retourner toutes les citations
  return allQuotes; // Tu peux filtrer si addedAt existe
});

// ← NOUVEAU: Provider pour les notes de métriques du mois sélectionné
final monthMetricNotesProvider = FutureProvider<List>((ref) async {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final allNotes = await ref.watch(allMetricNotesProvider.future);
  
  return allNotes.where((note) {
    return note.createdAt.year == selectedMonth.year &&
           note.createdAt.month == selectedMonth.month;
  }).toList();
});

// Notifier pour gérer les actions
final journalNotifierProvider = StateNotifierProvider<JournalNotifier, AsyncValue<void>>(
  (ref) => JournalNotifier(ref),
);

class JournalNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  JournalNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<bool> addEntry(String content, {List<String> tags = const []}) async {
    state = const AsyncValue.loading();

    try {
      final entry = JournalEntry(
        id: const Uuid().v4(),
        content: content,
        createdAt: DateTime.now(),
        tags: tags,
      );

      final repository = await ref.read(journalRepositoryProvider.future);
      final result = await repository.saveEntry(entry);

      return result.fold(
        (failure) {
          state = AsyncValue.error(failure, StackTrace.current);
          return false;
        },
        (_) {
          state = const AsyncValue.data(null);
          ref.invalidate(allJournalEntriesProvider);
          ref.invalidate(monthJournalEntriesProvider);
          return true;
        },
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<bool> updateEntry(String id, String content, {List<String>? tags}) async {
    try {
      final repository = await ref.read(journalRepositoryProvider.future);
      final currentEntry = await repository.getEntry(id);
      
      await currentEntry.fold(
        (failure) => throw failure,
        (entry) async {
          if (entry != null) {
            final updated = entry.copyWith(
              content: content,
              updateAt: DateTime.now(),
              tags: tags ?? entry.tags,
            );
            await repository.saveEntry(updated);
          }
        },
      );

      ref.invalidate(allJournalEntriesProvider);
      ref.invalidate(monthJournalEntriesProvider);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      final repository = await ref.read(journalRepositoryProvider.future);
      await repository.deleteEntry(id);
      ref.invalidate(allJournalEntriesProvider);
      ref.invalidate(monthJournalEntriesProvider);
    } catch (e) {
      print('Error deleting entry: $e');
    }
  }
}