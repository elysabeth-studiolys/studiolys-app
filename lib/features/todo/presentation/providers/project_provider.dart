import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/project_local_datasource.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';

final projectLocalDataSourceProvider = FutureProvider<ProjectLocalDataSource>((ref) async {
  final dataSource = ProjectLocalDataSource();
  await dataSource.init();
  return dataSource;
});

final projectRepositoryProvider = FutureProvider<ProjectRepository>((ref) async {
  final dataSource = await ref.watch(projectLocalDataSourceProvider.future);
  return ProjectRepositoryImpl(dataSource);
});

final allProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final repository = await ref.watch(projectRepositoryProvider.future);
  final result = await repository.getAllProjects();
  return result.fold(
    (failure) => [],
    (projects) => projects,
  );
});

final projectNotifierProvider = StateNotifierProvider<ProjectNotifier, AsyncValue<void>>(
  (ref) => ProjectNotifier(ref),
);

class ProjectNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ProjectNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<bool> addProject({
    required String title,
    required String category,
    String? description,
    DateTime? dueDate,
    ProjectPriority priority = ProjectPriority.medium,
  }) async {
    state = const AsyncValue.loading();

    try {
      final project = Project(
        id: const Uuid().v4(),
        title: title,
        category: category,
        description: description,
        dueDate: dueDate,
        priority: priority,
      );

      final repository = await ref.read(projectRepositoryProvider.future);
      final result = await repository.saveProject(project);

      return result.fold(
        (failure) {
          state = AsyncValue.error(failure, StackTrace.current);
          return false;
        },
        (_) {
          state = const AsyncValue.data(null);
          ref.invalidate(allProjectsProvider);
          return true;
        },
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<void> toggleProjectDone(String id) async {
    try {
      final repository = await ref.read(projectRepositoryProvider.future);
      await repository.toggleProjectDone(id);
      ref.invalidate(allProjectsProvider);
    } catch (e) {
      print('Error toggling project: $e');
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      final repository = await ref.read(projectRepositoryProvider.future);
      await repository.deleteProject(id);
      ref.invalidate(allProjectsProvider);
    } catch (e) {
      print('Error deleting project: $e');
    }
  }
}