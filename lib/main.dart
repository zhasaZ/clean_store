import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'src/presentation/bloc/favorites/favorites_cubit.dart';
import 'src/presentation/bloc/products/products_bloc.dart';
import 'src/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProductsBloc>()..add(const LoadProducts())),
        BlocProvider(create: (_) => getIt<FavoritesCubit>()..load()),
      ],
      child: MaterialApp(
        title: 'Clean Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const HomePage(),
      ),
    );
  }
}
