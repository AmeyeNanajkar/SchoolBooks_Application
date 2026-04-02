class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  AppException({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() => 'AppException: $message (Status: $statusCode)';
}

class ServerException extends AppException {
  ServerException({super.message = 'Server error', super.statusCode, super.error});
}

class NetworkException extends AppException {
  NetworkException({super.message = 'Network error', super.statusCode, super.error});
}

class CacheException extends AppException {
  CacheException({super.message = 'Cache error', super.statusCode, super.error});
}

class AuthException extends AppException {
  AuthException({super.message = 'Auth error', super.statusCode, super.error});
}

class ValidationException extends AppException {
  ValidationException({super.message = 'Validation error', super.statusCode, super.error});
}

class NotFoundException extends AppException {
  NotFoundException({super.message = 'Not found', super.statusCode, super.error});
}
