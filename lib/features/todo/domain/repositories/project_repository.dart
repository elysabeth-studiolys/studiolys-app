import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/project.dart';

abstract class ProjectRepository {
  Future<Either<Failure, void>> saveProject(Project project);
  Future<Either<Failure, List<Project>>> getAllProjects();
  Future<Either<Failure, Project?>> getProject(String id);
  Future<Either<Failure, void>> deleteProject(String id);
  Future<Either<Failure, void>> toggleProjectDone(String id);
}