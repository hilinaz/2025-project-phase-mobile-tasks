import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    )
  ], child: MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(context)=>HomePage(),
      '/detail':(context)=>DetailProduct(),
      '/add_product':(context)=>AddProduct(),
    },
  )));
}
