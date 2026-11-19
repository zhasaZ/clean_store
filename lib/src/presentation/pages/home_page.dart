import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorites/favorites_cubit.dart';
import 'favorites_page.dart';
import 'products_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null && curr.errorMessage != prev.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_index == 0 ? 'Магазин' : 'Избранное')),
        // IndexedStack сохраняет состояние вкладок: без повторных запросов.
        body: IndexedStack(
          index: _index,
          children: const [ProductsPage(), FavoritesPage()],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.store), label: 'Товары'),
            NavigationDestination(
                icon: Icon(Icons.favorite), label: 'Избранное'),
          ],
        ),
      ),
    );
  }
}
