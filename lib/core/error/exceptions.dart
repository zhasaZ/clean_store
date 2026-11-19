/// Исключения Data Layer. Репозиторий превращает их в Failure.
class AppException implements Exception {
  const AppException();
}

class NetworkException extends AppException {
  const NetworkException();
}

class ServerException extends AppException {
  const ServerException();
}

class UnauthorizedException extends AppException {
  const UnauthorizedException();
}

class ValidationException extends AppException {
  const ValidationException();
}

class CacheException extends AppException {
  const CacheException();
}

class UnknownException extends AppException {
  const UnknownException();
}
