import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/api_constants.dart';
import '../../src/data/datasources/favorites_local_datasource.dart';
import '../../src/data/datasources/product_remote_datasource.dart';
import '../../src/data/repositories/favorites_repository_impl.dart';
import '../../src/data/repositories/product_repository_impl.dart';
import '../../src/domain/repositories/favorites_repository.dart';
import '../../src/domain/repositories/product_repository.dart';
import '../../src/domain/usecases/get_favorites_usecase.dart';
import '../../src/domain/usecases/get_products_usecase.dart';
import '../../src/domain/usecases/toggle_favorite_usecase.dart';
import '../../src/presentation/bloc/favorites/favorites_cubit.dart';
import '../../src/presentation/bloc/products/products_bloc.dart';
import '../rest_client/api_client.dart';

final getIt = GetIt.instance;

/// Порядок регистрации: внешние -> datasources -> repositories -> usecases -> bloc.
Future<void> configureDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.timeout,
      receiveTimeout: ApiConstants.timeout,
    )),
  );
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  // Data sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductRemoteDataSource>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(getIt<FavoritesLocalDataSource>()),
  );

  // Use cases
  getIt.registerFactory(() => GetProductsUseCase(getIt<ProductRepository>()));
  getIt.registerFactory(() => GetFavoritesUseCase(getIt<FavoritesRepository>()));
  getIt.registerFactory(() => ToggleFavoriteUseCase(getIt<FavoritesRepository>()));

  // Bloc / Cubit
  getIt.registerFactory(() => ProductsBloc(getIt<GetProductsUseCase>()));
  getIt.registerFactory(() => FavoritesCubit(
        getFavorites: getIt<GetFavoritesUseCase>(),
        toggleFavorite: getIt<ToggleFavoriteUseCase>(),
      ));
}
