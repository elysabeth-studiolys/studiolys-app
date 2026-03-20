import '../../../../core/services/storage/hive_service.dart';
import '../models/metric_note_model.dart';

abstract class MetricNoteDataSource {
  Future<List<MetricNoteModel>> getNotes(String metricType, DateTime weekStart);
  Future<List<MetricNoteModel>> getAllNotes(); 
  Future<void> addNote(MetricNoteModel note);
  Future<void> deleteNote(String id);
}

class MetricNoteDataSourceImpl implements MetricNoteDataSource {
  final HiveService hiveService;

  MetricNoteDataSourceImpl(this.hiveService);

  @override
  Future<List<MetricNoteModel>> getNotes(String metricType, DateTime weekStart) async {
    final box = await hiveService.metricNotesBox;
    return box.values
        .cast<MetricNoteModel>()
        .where((note) => 
          note.metricType == metricType &&
          note.weekStart.year == weekStart.year &&
          note.weekStart.month == weekStart.month &&
          note.weekStart.day == weekStart.day
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<MetricNoteModel>> getAllNotes() async {
    final box = await hiveService.metricNotesBox;
    final notes = box.values.cast<MetricNoteModel>().toList();
    // Trier par date (plus récent en premier)
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  @override
  Future<void> addNote(MetricNoteModel note) async {
    final box = await hiveService.metricNotesBox;
    await box.add(note);
  }

  @override
  Future<void> deleteNote(String id) async {
    final box = await hiveService.metricNotesBox;
    final key = box.keys.firstWhere(
      (key) => (box.get(key) as MetricNoteModel).id == id,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
    }
  }
}