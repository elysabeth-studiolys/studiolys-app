import 'package:hive/hive.dart';
import '../../domain/entities/project_task.dart';

part 'project_task_model.g.dart';

@HiveType(typeId: 7)
class ProjectTaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isDone;

  @HiveField(3)
  final DateTime createdAt;

  ProjectTaskModel({
    required this.id,
    required this.title,
    required this.isDone,
    required this.createdAt,
  });

  factory ProjectTaskModel.fromEntity(ProjectTask entity) {
    return ProjectTaskModel(
      id: entity.id,
      title: entity.title,
      isDone: entity.isDone,
      createdAt: entity.createdAt,
    );
  }

  ProjectTask toEntity() {
    return ProjectTask(
      id: id,
      title: title,
      isDone: isDone,
      createdAt: createdAt,
    );
  }
}