import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/sign_in_screen.dart';
import 'features/auth/presentation/pages/sign_up_screen.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/pages/add_product_page.dart';
import 'features/products/presentation/pages/detail_product_page.dart';

import 'features/products/presentation/pages/home_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<ProductBloc>(
      create: (context) => di.sl<ProductBloc>(),
    ),
    BlocProvider<AuthBloc>(create: (context)=>di.sl<AuthBloc>())
  ], child: MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(context)=>SplashScreen(),
      
      '/signup':(context)=>SignUpScreen(),
      '/signin':(context)=>SignInScreen(),
      '/home': (context)=>HomePage(),
      '/detail':(context)=>DetailProduct(),
      '/add_product':(context)=>AddProduct(),
    },
  )));
}
