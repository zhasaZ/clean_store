import 'package:equatable/equatable.dart';

/// Ошибки, которые видят Domain и Presentation слои.
/// Никаких технических деталей (Dio, сокеты и т.д.) здесь нет.
abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

/// Нет интернета / таймаут.
class NetworkFailure extends Failure {
  const NetworkFailure();
}

/// Ошибка сервера (5xx и прочее).
class ServerFailure extends Failure {
  const ServerFailure();
}

/// 401 / 403.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

/// 400.
class ValidationFailure extends Failure {
  const ValidationFailure();
}

/// Ошибка локального хранилища.
class CacheFailure extends Failure {
  const CacheFailure();
}

/// Всё остальное.
class UnknownFailure extends Failure {
  const UnknownFailure();
}
