import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_message.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_products_usecase.dart';

// ---------- Events ----------
abstract class ProductsEvent {
  const ProductsEvent();
}

/// Первая загрузка. Повторные вызовы игнорируются, если данные уже есть.
class LoadProducts extends ProductsEvent {
  const LoadProducts();
}

/// Принудительная перезагрузка (retry / pull-to-refresh).
class RefreshProducts extends ProductsEvent {
  final Completer<void>? completer;
  const RefreshProducts({this.completer});
}

// ---------- States ----------
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductsEmpty extends ProductsState {
  const ProductsEmpty();
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ---------- Bloc ----------
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProducts;

  ProductsBloc(this.getProducts) : super(const ProductsInitial()) {
    on<LoadProducts>(_onLoad);
    on<RefreshProducts>(_onRefresh);
  }

  Future<void> _onLoad(LoadProducts event, Emitter<ProductsState> emit) async {
    // Не делаем лишний запрос, если уже грузим или всё загружено.
    if (state is ProductsLoading ||
        state is ProductsLoaded ||
        state is ProductsEmpty) {
      return;
    }
    emit(const ProductsLoading());
    await _fetch(emit);
  }

  Future<void> _onRefresh(
      RefreshProducts event, Emitter<ProductsState> emit) async {
    if (state is ProductsLoading) {
      event.completer?.complete();
      return;
    }
    // Если список уже на экране, не заменяем его спиннером.
    if (state is! ProductsLoaded) emit(const ProductsLoading());
    await _fetch(emit);
    event.completer?.complete();
  }

  Future<void> _fetch(Emitter<ProductsState> emit) async {
    final result = await getProducts();
    result.fold(
      (failure) => emit(ProductsError(failureMessage(failure))),
      (products) => products.isEmpty
          ? emit(const ProductsEmpty())
          : emit(ProductsLoaded(products)),
    );
  }
}
