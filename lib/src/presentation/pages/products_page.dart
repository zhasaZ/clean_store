import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/state_views.dart';
import '../bloc/favorites/favorites_cubit.dart';
import '../bloc/products/products_bloc.dart';
import '../widgets/product_card.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading || state is ProductsInitial) {
          return const LoadingView();
        }
        if (state is ProductsError) {
          return ErrorView(
            message: state.message,
            onRetry: () =>
                context.read<ProductsBloc>().add(const RefreshProducts()),
          );
        }
        if (state is ProductsEmpty) {
          return const EmptyView(message: 'Товаров пока нет');
        }
        final products = (state as ProductsLoaded).products;
        return RefreshIndicator(
          onRefresh: () {
            final completer = Completer<void>();
            context
                .read<ProductsBloc>()
                .add(RefreshProducts(completer: completer));
            return completer.future;
          },
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, favState) => ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, i) {
                final p = products[i];
                return ProductCard(
                  product: p,
                  isFavorite: favState.isFavorite(p.id),
                  onFavoriteTap: () => context.read<FavoritesCubit>().toggle(p),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
