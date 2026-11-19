import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/state_views.dart';
import '../bloc/favorites/favorites_cubit.dart';
import '../widgets/product_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.isLoading) return const LoadingView();
        if (state.items.isEmpty) {
          return EmptyView(
            message: state.errorMessage ?? 'В избранном пока ничего нет',
            icon: Icons.favorite_border,
          );
        }
        return ListView.builder(
          itemCount: state.items.length,
          itemBuilder: (context, i) {
            final p = state.items[i];
            return ProductCard(
              product: p,
              isFavorite: true,
              onFavoriteTap: () => context.read<FavoritesCubit>().toggle(p),
            );
          },
        );
      },
    );
  }
}
