import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_message.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_favorites_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';

class FavoritesState extends Equatable {
  final List<Product> items;
  final bool isLoading;

  /// Одноразовое сообщение об ошибке (показываем в SnackBar).
  final String? errorMessage;

  const FavoritesState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  bool isFavorite(int productId) => items.any((p) => p.id == productId);

  @override
  List<Object?> get props => [items, isLoading, errorMessage];
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase getFavorites;
  final ToggleFavoriteUseCase toggleFavorite;

  FavoritesCubit({
    required this.getFavorites,
    required this.toggleFavorite,
  }) : super(const FavoritesState());

  Future<void> load() async {
    emit(const FavoritesState(isLoading: true));
    final result = await getFavorites(const NoParams());
    result.fold(
      (failure) => emit(FavoritesState(errorMessage: failureMessage(failure))),
      (items) => emit(FavoritesState(items: items)),
    );
  }

  Future<void> toggle(Product product) async {
    final result = await toggleFavorite(product);
    result.fold(
      (failure) => emit(FavoritesState(
        items: state.items,
        errorMessage: failureMessage(failure),
      )),
      (items) => emit(FavoritesState(items: items)),
    );
  }
}
