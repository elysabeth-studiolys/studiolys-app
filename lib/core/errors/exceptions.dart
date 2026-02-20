/// Exception de base de l'application
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

/// Exception de stockage
class StorageException extends AppException {
  StorageException(super.message, [super.code]);
}

/// Exception de cache
class CacheException extends AppException {
  CacheException(super.message, [super.code]);
}

/// Exception réseau
class NetworkException extends AppException {
  NetworkException(super.message, [super.code]);
}

/// Exception de serveur
class ServerException extends AppException {
  final int? statusCode;

  ServerException(super.message, [super.code, this.statusCode]);
}

/// Exception de validation
class ValidationException extends AppException {
  ValidationException(super.message, [super.code]);
}

/// Exception d'authentification
class AuthException extends AppException {
  AuthException(super.message, [super.code]);
}

/// Exception de ressource non trouvée
class NotFoundException extends AppException {
  NotFoundException(super.message, [super.code]);
}

/// Exception de parsing
class ParsingException extends AppException {
  ParsingException(super.message, [super.code]);
}
