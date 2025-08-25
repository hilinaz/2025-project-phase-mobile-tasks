import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/sign_in_screen.dart';
import 'features/auth/presentation/pages/sign_up_screen.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/chat/presentaion/bloc/chat_bloc.dart';
import 'features/chat/presentaion/pages/chat_list_page.dart';
import 'features/chat/presentaion/pages/chat_page.dart';
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
    BlocProvider<AuthBloc>(create: (context)=>di.sl<AuthBloc>()),
     BlocProvider<ChatBloc>(create: (context) => di.sl<ChatBloc>())
  ], child: MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(context)=>const SplashScreen(),
      
      '/signup':(context)=>const SignUpScreen(),
      '/signin':(context)=> const SignInScreen(),
      '/home': (context)=> const HomePage(),
      '/detail':(context)=>const DetailProduct(),
      '/add_product':(context)=>const AddProduct(),
      '/chats':(context)=> const ChatListPage(),
      '/chat': (context)=> const ChatPage()
    },
  )));
}
