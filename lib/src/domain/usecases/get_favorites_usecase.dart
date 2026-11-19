import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase implements UseCase<List<Product>, NoParams> {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call([NoParams params = const NoParams()]) {
    return repository.getFavorites();
  }
}
