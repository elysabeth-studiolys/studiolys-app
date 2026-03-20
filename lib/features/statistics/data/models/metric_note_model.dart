import 'package:hive/hive.dart';
import '../../domain/entities/metric_note.dart';

part 'metric_note_model.g.dart';

@HiveType(typeId: 3)
class MetricNoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String metricType;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime weekStart;

  @HiveField(4)
  final DateTime createdAt;

  MetricNoteModel({
    required this.id,
    required this.metricType,
    required this.content,
    required this.weekStart,
    required this.createdAt,
  });

  factory MetricNoteModel.fromEntity(MetricNote entity) {
    return MetricNoteModel(
      id: entity.id,
      metricType: entity.metricType,
      content: entity.content,
      weekStart: entity.weekStart,
      createdAt: entity.createdAt,
    );
  }

  MetricNote toEntity() {
    return MetricNote(
      id: id,
      metricType: metricType,
      content: content,
      weekStart: weekStart,
      createdAt: createdAt,
    );
  }
}