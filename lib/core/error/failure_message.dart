import 'failures.dart';

/// Единая точка превращения Failure в текст для пользователя.
/// Технический текст исключений пользователю никогда не показывается.
String failureMessage(Failure failure) {
  if (failure is NetworkFailure) {
    return 'Нет подключения к интернету. Проверьте сеть и повторите попытку.';
  }
  if (failure is ServerFailure) {
    return 'Ошибка сервера. Попробуйте позже.';
  }
  if (failure is UnauthorizedFailure) {
    return 'Требуется авторизация. Войдите в аккаунт.';
  }
  if (failure is ValidationFailure) {
    return 'Неверный запрос. Попробуйте ещё раз.';
  }
  if (failure is CacheFailure) {
    return 'Не удалось прочитать или сохранить данные на устройстве.';
  }
  return 'Произошла неизвестная ошибка.';
}
