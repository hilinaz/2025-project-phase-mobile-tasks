import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/sign_in_page.dart';
import 'features/auth/presentation/sign_up_page.dart';
import 'features/auth/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            signIn: Login(AuthRepositoryImpl(
              networkInfo: NetworkInfoImp(InternetConnectionChecker()),
              localDatasource: AuthLocalDatasourceImp(sharedPreferences),
              remoteDatasource: AuthRemoteDatasourceImp(http.Client()),
            )),
            signUp: SignUp(AuthRepositoryImpl(
              networkInfo: NetworkInfoImp(InternetConnectionChecker()),
              localDatasource: AuthLocalDatasourceImp(sharedPreferences),
              remoteDatasource: AuthRemoteDatasourceImp(http.Client()),
            )),
            logout: Logout(AuthRepositoryImpl(
              networkInfo: NetworkInfoImp(InternetConnectionChecker()),
              localDatasource: AuthLocalDatasourceImp(sharedPreferences),
              remoteDatasource: AuthRemoteDatasourceImp(http.Client()),
            )),
          ),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/signup': (context) => SignUpPage(),
          '/signin': (context) => SignInPage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
