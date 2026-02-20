import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_local_datasource.dart';
import '../models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource localDataSource;

  ProjectRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveProject(Project project) async {
    try {
      final model = ProjectModel.fromEntity(project);
      await localDataSource.saveProject(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Project>>> getAllProjects() async {
    try {
      final models = localDataSource.getAllProjects();
      final projects = models.map((m) => m.toEntity()).toList();
      projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(projects);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Project?>> getProject(String id) async {
    try {
      final model = localDataSource.getProject(id);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProject(String id) async {
    try {
      await localDataSource.deleteProject(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleProjectDone(String id) async {
    try {
      await localDataSource.toggleProjectDone(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}