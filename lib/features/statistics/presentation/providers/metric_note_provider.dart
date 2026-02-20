import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/metric_note_datasource.dart';
import '../../domain/entities/metric_note.dart';
import '../../data/models/metric_note_model.dart';
import '../../../../core/services/storage/hive_service.dart';

final metricNoteDataSourceProvider = Provider<MetricNoteDataSource>((ref) {
  return MetricNoteDataSourceImpl(HiveService.instance);
});


final metricNotesProvider = FutureProvider.family<List<MetricNote>, ({String metricType, DateTime weekStart})>(
  (ref, params) async {
    final dataSource = ref.watch(metricNoteDataSourceProvider);
    final notes = await dataSource.getNotes(params.metricType, params.weekStart);
    return notes.map((model) => model.toEntity()).toList();
  },
);

class MetricNoteNotifier extends StateNotifier<AsyncValue<void>> {
  final MetricNoteDataSource dataSource;
  final Ref ref;

  MetricNoteNotifier(this.dataSource, this.ref) : super(const AsyncValue.data(null));

  Future<bool> addNote(String metricType, DateTime weekStart, String content) async {
    state = const AsyncValue.loading();
    
    try {
      final note = MetricNoteModel(
        id: const Uuid().v4(),
        metricType: metricType,
        weekStart: weekStart,
        content: content,
        createdAt: DateTime.now(),
      );
      
      await dataSource.addNote(note);
      
      ref.invalidate(metricNotesProvider);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<bool> deleteNote(String id) async {
    state = const AsyncValue.loading();
    
    try {
      await dataSource.deleteNote(id);
      
      ref.invalidate(metricNotesProvider);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

final metricNoteNotifierProvider = StateNotifierProvider<MetricNoteNotifier, AsyncValue<void>>((ref) {
  final dataSource = ref.watch(metricNoteDataSourceProvider);
  return MetricNoteNotifier(dataSource, ref);
});