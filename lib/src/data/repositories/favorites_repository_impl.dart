import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';
import '../mapper/product_mapper.dart';
import 'product_repository_impl.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Product>>> getFavorites() async {
    try {
      final models = await localDataSource.getFavorites();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> toggleFavorite(Product product) async {
    try {
      final current = await localDataSource.getFavorites();
      final exists = current.any((e) => e.id == product.id);
      final updated = exists
          ? current.where((e) => e.id != product.id).toList()
          : [...current, product.toModel()];
      await localDataSource.saveFavorites(updated);
      return Right(updated.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
