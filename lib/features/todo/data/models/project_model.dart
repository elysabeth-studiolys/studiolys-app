import 'package:hive/hive.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_task.dart';
import 'project_task_model.dart';

part 'project_model.g.dart';

@HiveType(typeId: 6)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final DateTime? dueDate;

  @HiveField(5)
  final bool isDone;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final int priority;

  @HiveField(8)
  final List<ProjectTaskModel> tasks;

  ProjectModel({
    required this.id,
    required this.title,
    required this.category,
    this.description,
    this.dueDate,
    required this.isDone,
    required this.createdAt,
    required this.priority,
    required this.tasks,
  });

  factory ProjectModel.fromEntity(Project entity) {
    return ProjectModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      description: entity.description,
      dueDate: entity.dueDate,
      isDone: entity.isDone,
      createdAt: entity.createdAt,
      priority: entity.priority.index,
      tasks: entity.tasks
          .map((task) => ProjectTaskModel.fromEntity(task))
          .toList(),
    );
  }

  Project toEntity() {
    return Project(
      id: id,
      title: title,
      category: category,
      description: description,
      dueDate: dueDate,
      isDone: isDone,
      createdAt: createdAt,
      priority: ProjectPriority.values[priority],
      tasks: tasks.map((task) => task.toEntity()).toList(),
    );
  }
}