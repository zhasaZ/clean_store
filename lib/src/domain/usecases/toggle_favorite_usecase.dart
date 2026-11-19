import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase implements UseCase<List<Product>, Product> {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(Product params) {
    return repository.toggleFavorite(params);
  }
}
