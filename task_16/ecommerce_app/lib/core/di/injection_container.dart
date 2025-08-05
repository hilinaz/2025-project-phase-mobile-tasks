import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../platform/network_info.dart';
import '../services/http_service.dart';
import '../../features/products/data/datasources/product_local_datasource.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/datasources/product_remote_datasource_impl.dart';
import '../../features/products/data/repository/product_repository_impl.dart';
import '../../features/products/doamin/repositories/product_repository.dart';
import '../../features/products/doamin/usecases/create_new_product.dart';
import '../../features/products/doamin/usecases/delete_product.dart';
import '../../features/products/doamin/usecases/update_product.dart';
import '../../features/products/doamin/usecases/view_all_products.dart';
import '../../features/products/doamin/usecases/view_specific_product.dart';
import '../../features/products/presentation/bloc/products_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Products
  _initProducts();

  // Core
  _initCore();

  // External
  await _initExternal();
}

void _initProducts() {
  // Use cases
  sl.registerLazySingleton(() => ViewAllProductsUsecase(sl()));
  sl.registerLazySingleton(() => ViewProductUsecase(sl()));
  sl.registerLazySingleton(() => CreateProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));

  // BLoC
  sl.registerFactory(() => ProductsBloc(
    viewAllProducts: sl(),
    viewProduct: sl(),
    createProduct: sl(),
    updateProduct: sl(),
    deleteProduct: sl(),
  ));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDatasource: sl(),
      localDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(httpService: sl()),
  );
  sl.registerLazySingleton<ProductLocalDatasource>(
    () => ProductLocalDatasourceImpl(sharedPreferences: sl()),
  );
}

void _initCore() {
  // Network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  
  // HTTP Service
  sl.registerLazySingleton(() => HttpService(client: sl()));
}

Future<void> _initExternal() async {
  // HTTP Client
  sl.registerLazySingleton(() => http.Client());
  
  // Internet Connection Checker
  sl.registerLazySingleton(() => InternetConnectionChecker());
  
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
} 