import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart ' as IO;

import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/chat/data/datasources/chat_local_datasources.dart';
import 'features/chat/data/datasources/chat_remote_datasources.dart';
import 'features/chat/data/datasources/chat_socket_datasources.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/delete_chat.dart';
import 'features/chat/domain/usecases/get_all_user.dart';
import 'features/chat/domain/usecases/get_chat_by_id.dart';
import 'features/chat/domain/usecases/get_chat_messages.dart';
import 'features/chat/domain/usecases/get_my_chats.dart';
import 'features/chat/domain/usecases/init_chat.dart';
import 'features/chat/domain/usecases/mark_as_recieved.dart';
import 'features/chat/domain/usecases/on_message_recieved.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentaion/bloc/chat_bloc.dart';
import 'features/products/data/datasources/product_local_datasource.dart';
import 'features/products/data/datasources/product_remote_datasource.dart';
import 'features/products/data/repository/product_repository_impl.dart';
import 'features/products/doamin/repositories/product_repository.dart';
import 'features/products/doamin/usecases/create_new_product.dart' as create;
import 'features/products/doamin/usecases/delete_product.dart' as delete;
import 'features/products/doamin/usecases/update_product.dart' as update;
import 'features/products/doamin/usecases/view_all_products.dart' as view_All;
import 'features/products/doamin/usecases/view_specific_product.dart'
    as view_Specific;
import 'features/products/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Products

  // Bloc
  sl.registerFactory(() => ProductBloc(
        createProductUsecase: sl(),
        updateProductUsecase: sl(),
        deleteProductUsecase: sl(),
        getAllProductsUsecase: sl(),
        getProductUsecase: sl(),
      ));

  // Usecases
  sl.registerLazySingleton(() => create.CreateProductUsecase(sl()));
  sl.registerLazySingleton(() => update.UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => delete.DeleteProductUsecase(sl()));
  sl.registerLazySingleton(() => view_All.ViewAllProductsUsecase(sl()));
  sl.registerLazySingleton(() => view_Specific.ViewProductUsecase(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(
        localDatasource: sl(),
        remoteDatasource: sl(),
        networkInfo: sl(),
      ));

  // Data sources
  sl.registerLazySingleton<ProductLocalDatasource>(
      () => ProductLocalDatasourceImp(sl()));
  sl.registerLazySingleton<ProductRemoteDatasource>(
      () => ProductRemoteDatasourceImp(sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());


  // AUTH
//Bloc
  sl.registerFactory(() => AuthBloc(signUp: sl(), login: sl(), logout: sl()));

//usecase
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));

//repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl(), sl()));

//datasources
  sl.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasourceImp(sl()));
  sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(sl(), sl()));

  //CHAT

  // Bloc
  sl.registerFactory(() => ChatBloc(
      getMyChats: sl(),
      getChatById: sl(),
      deleteChat: sl(),
      sendMessage: sl(),
      onMessageReceived: sl(),
      initChat: sl(),
      markAsRecieved: sl(), 
      getAllUser: sl(), 
      getChatMessages: sl()));
      

  // Usecases
  sl.registerLazySingleton(() => GetAllUser(sl()));
  sl.registerLazySingleton(() => DeleteChat(sl()));
  sl.registerLazySingleton(() => GetChatById(sl()));
  sl.registerLazySingleton(() => GetMyChats(sl()));
  sl.registerLazySingleton(() => GetChatMessages(sl()));
  sl.registerLazySingleton(() => InitChat(sl()));
  sl.registerLazySingleton(() => MarkAsRecieved(sl()));
  sl.registerLazySingleton(() => OnMessageReceived(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  // // Repository
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      socketDatasources: sl(),
      networkInfo: sl()));

  // // Data sources
  sl.registerLazySingleton<ChatLocalDatasources>(
      () => ChatLocalDatasourcesImpl(sl()));
  sl.registerLazySingleton<ChatRemoteDatasources>(
      () => ChatRemoteDatasourcesImpl(sl(), sl()));

  sl.registerLazySingleton<ChatSocketDatasources>(
      () => ChatSocketDatasourcesImpl(socket: null, authLocalDatasource: sl()));

  //! External
sl.registerLazySingleton<IO.Socket>(() => IO.io(sl()));


}



       




  