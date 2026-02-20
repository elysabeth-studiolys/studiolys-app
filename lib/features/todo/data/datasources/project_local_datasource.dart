import 'package:hive_flutter/hive_flutter.dart';
import '../models/project_model.dart';

class ProjectLocalDataSource {
  static const String boxName = 'projects';
  late Box<ProjectModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<ProjectModel>(boxName);
  }

  Future<void> saveProject(ProjectModel project) async {
    await _box.put(project.id, project);
  }

  List<ProjectModel> getAllProjects() {
    return _box.values.toList();
  }

  ProjectModel? getProject(String id) {
    return _box.get(id);
  }

  Future<void> deleteProject(String id) async {
    await _box.delete(id);
  }

  Future<void> toggleProjectDone(String id) async {
    final project = _box.get(id);
    if (project != null) {
      final updated = ProjectModel(
        id: project.id,
        title: project.title,
        category: project.category,
        description: project.description,
        dueDate: project.dueDate,
        isDone: !project.isDone,
        createdAt: project.createdAt,
        priority: project.priority,
        tasks: project.tasks,
      );
      await _box.put(id, updated);
    }
  }
}