import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/metric_note_datasource.dart';
import '../../data/models/metric_note_model.dart';
import '../../domain/entities/metric_note.dart';
import '../../../../core/services/storage/hive_service.dart';

// Provider pour le datasource
final metricNoteDataSourceProvider = Provider<MetricNoteDataSource>((ref) {
  return MetricNoteDataSourceImpl(HiveService.instance);
});

// Provider pour toutes les notes de métriques
final allMetricNotesProvider = FutureProvider<List<MetricNote>>((ref) async {
  final dataSource = ref.watch(metricNoteDataSourceProvider);
  final models = await dataSource.getAllNotes();
  
  // Convertir MetricNoteModel en MetricNote entity
  return models.map((model) => MetricNote(
    id: model.id,
    metricType: model.metricType,
    content: model.content,
    weekStart: model.weekStart,
    createdAt: model.createdAt,
  )).toList();
});

// Provider pour les notes d'une semaine/métrique spécifique
// ← CORRIGÉ: accepte un Record avec metricType et weekStart
final metricNotesProvider = FutureProvider.family<List<MetricNote>, ({String metricType, DateTime weekStart})>(
  (ref, params) async {
    final dataSource = ref.watch(metricNoteDataSourceProvider);
    final models = await dataSource.getNotes(params.metricType, params.weekStart);
    
    return models.map((model) => MetricNote(
      id: model.id,
      metricType: model.metricType,
      content: model.content,
      weekStart: model.weekStart,
      createdAt: model.createdAt,
    )).toList();
  },
);

// Notifier pour gérer les actions
final metricNoteNotifierProvider = StateNotifierProvider<MetricNoteNotifier, AsyncValue<void>>(
  (ref) => MetricNoteNotifier(ref),
);

class MetricNoteNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  MetricNoteNotifier(this.ref) : super(const AsyncValue.data(null));

  // ← CORRIGÉ: signature avec 3 paramètres dans le bon ordre
  Future<bool> addNote(String metricType, DateTime weekStart, String content) async {
    state = const AsyncValue.loading();

    try {
      final dataSource = ref.read(metricNoteDataSourceProvider);
      
      final note = MetricNoteModel(
        id: const Uuid().v4(),
        metricType: metricType,
        content: content,
        weekStart: weekStart,
        createdAt: DateTime.now(),
      );

      await dataSource.addNote(note);
      
      state = const AsyncValue.data(null);
      ref.invalidate(allMetricNotesProvider);
      ref.invalidate(metricNotesProvider((
        metricType: metricType,
        weekStart: weekStart,
      )));
      
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final dataSource = ref.read(metricNoteDataSourceProvider);
      await dataSource.deleteNote(noteId);
      ref.invalidate(allMetricNotesProvider);
    } catch (e) {
      print('Error deleting note: $e');
    }
  }
}