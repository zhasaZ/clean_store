import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../mapper/product_mapper.dart';

Failure mapExceptionToFailure(Object e) {
  if (e is NetworkException) return const NetworkFailure();
  if (e is ServerException) return const ServerFailure();
  if (e is UnauthorizedException) return const UnauthorizedFailure();
  if (e is ValidationException) return const ValidationFailure();
  if (e is CacheException) return const CacheFailure();
  return const UnknownFailure();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final models = await remoteDataSource.getProducts();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
