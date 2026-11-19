import 'package:clean_store/core/error/exceptions.dart';
import 'package:clean_store/core/error/failures.dart';
import 'package:clean_store/models/product_model.dart';
import 'package:clean_store/src/data/datasources/product_remote_datasource.dart';
import 'package:clean_store/src/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemote implements ProductRemoteDataSource {
  final Object? error;
  final List<ProductModel> data;
  _FakeRemote({this.error, this.data = const []});

  @override
  Future<List<ProductModel>> getProducts() async {
    if (error != null) throw error!;
    return data;
  }
}

void main() {
  test('maps model to entity', () async {
    final repo = ProductRepositoryImpl(_FakeRemote(data: const [
      ProductModel(
          id: 1,
          title: 'A',
          price: 9.5,
          description: 'd',
          category: 'c',
          image: 'i',
          rating: 4),
    ]));
    final result = await repo.getProducts();
    expect(result.getOrElse(() => []).first.title, 'A');
  });

  test('exceptions become failures', () async {
    final cases = <Object, Failure>{
      const NetworkException(): const NetworkFailure(),
      const ServerException(): const ServerFailure(),
      const UnauthorizedException(): const UnauthorizedFailure(),
      const ValidationException(): const ValidationFailure(),
      Exception('boom'): const UnknownFailure(),
    };
    for (final e in cases.entries) {
      final repo = ProductRepositoryImpl(_FakeRemote(error: e.key));
      final result = await repo.getProducts();
      expect(result.fold((l) => l, (r) => null), e.value);
    }
  });
}
