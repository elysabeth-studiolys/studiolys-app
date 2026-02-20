import 'package:hive/hive.dart';
import '../../domain/entities/metric_note.dart';

part 'metric_note_model.g.dart';

@HiveType(typeId: 4)
class MetricNoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String metricType;

  @HiveField(2)
  final DateTime weekStart;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final DateTime createdAt;

  MetricNoteModel({
    required this.id,
    required this.metricType,
    required this.weekStart,
    required this.content,
    required this.createdAt,
  });

  MetricNote toEntity() {
    return MetricNote(
      id: id,
      metricType: metricType,
      weekStart: weekStart,
      content: content,
      createdAt: createdAt,
    );
  }

  factory MetricNoteModel.fromEntity(MetricNote note) {
    return MetricNoteModel(
      id: note.id,
      metricType: note.metricType,
      weekStart: note.weekStart,
      content: note.content,
      createdAt: note.createdAt,
    );
  }
}