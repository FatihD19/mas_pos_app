import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos_app/commons/theme.dart';
import 'package:mas_pos_app/core/di/service_locator.dart';
import 'package:mas_pos_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:mas_pos_app/feature/auth/presentation/pages/login_page.dart';
import 'package:mas_pos_app/feature/category/presentation/bloc/category_bloc.dart';

import 'package:mas_pos_app/feature/product/presentation/bloc/product/product_bloc.dart';
import 'package:mas_pos_app/feature/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:mas_pos_app/feature/product/presentation/bloc/cart/cart_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ProductBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<CategoryBloc>(),
        ),
        BlocProvider(
          create: (context) {
            final cartBloc = sl<CartBloc>();
            cartBloc.add(LoadCart()); // Load cart saat app start
            return cartBloc;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MASPOS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        ),
        home: LoginPage(),
      ),
    );
  }
}
