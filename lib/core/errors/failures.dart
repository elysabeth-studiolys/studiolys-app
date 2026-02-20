import 'package:equatable/equatable.dart';

/// Échec de base de l'application
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

/// Échec de stockage
class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.code]);
}

/// Échec de cache
class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.code]);
}

/// Échec réseau
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code]);
}

/// Échec de serveur
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, [super.code, this.statusCode]);

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Échec de validation
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.code]);
}

/// Échec d'authentification
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}

/// Échec de ressource non trouvée
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, [super.code]);
}

/// Échec de parsing
class ParsingFailure extends Failure {
  const ParsingFailure(super.message, [super.code]);
}

/// Échec générique
class GenericFailure extends Failure {
  const GenericFailure(super.message, [super.code]);
}
