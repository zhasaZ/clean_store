# Clean Store: Flutter, Clean Architecture (СРС 11)

## Запуск
```
flutter create .        # создаст android/ios/web папки, lib/ и pubspec.yaml не тронет
flutter pub get
flutter run
```

## Структура
```
lib/
├── components/        общие виджеты (Loading / Empty / Error)
├── constants/         URL API, ключи хранилища
├── models/            DTO (ProductModel)
├── core/
│   ├── error/         Failure, Exception, failureMessage
│   ├── rest_client/   ApiClient (Dio -> исключения Data Layer)
│   ├── usecase/       базовый UseCase
│   └── di/            GetIt
├── src/
│   ├── data/          datasources, mapper, repositories (Impl)
│   ├── domain/        entities, repositories (abstract), usecases
│   └── presentation/  pages, widgets, bloc
└── main.dart
```

## Обработка ошибок
| Ситуация | Exception (Data) | Failure (Domain) |
|---|---|---|
| Нет интернета / таймаут | NetworkException | NetworkFailure |
| 500 и прочие | ServerException | ServerFailure |
| 401 / 403 | UnauthorizedException | UnauthorizedFailure |
| 400 | ValidationException | ValidationFailure |
| Пустой список | (не ошибка) | состояние ProductsEmpty |
| Всё остальное | UnknownException | UnknownFailure |

Пользователю показывается только текст из `failureMessage()`.

## Новая функция: избранное с локальным сохранением
`FavoritesRepository` -> `GetFavoritesUseCase` / `ToggleFavoriteUseCase` ->
`FavoritesLocalDataSource` (SharedPreferences) -> `FavoritesCubit` -> вкладка «Избранное».
Работает офлайн.

## Тесты
`flutter test`
