import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Product>>> getFavorites();

  /// Добавляет товар в избранное или убирает его. Возвращает новый список.
  Future<Either<Failure, List<Product>>> toggleFavorite(Product product);
}
