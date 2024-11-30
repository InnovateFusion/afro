import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/shop/presentation/bloc/shop_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/internet.dart';
import 'features/auth/data/datasources/local/auth.dart';
import 'features/auth/data/datasources/remote/auth.dart';
import 'features/auth/data/repositories/auth.dart';
import 'features/auth/domain/repositories/auth.dart';
import 'features/auth/domain/usecases/load_currect_user.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/update_access_token.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/product/data/datasources/remote/product.dart';
import 'features/product/data/repositories/product.dart';
import 'features/product/domain/repositories/product.dart';
import 'features/product/domain/usecases/add_new_product.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/domain/usecases/product_approval.dart';
import 'features/shop/data/datasources/remote/shop.dart';
import 'features/shop/data/repositories/shop.dart';
import 'features/shop/domain/repositories/shop.dart';
import 'features/shop/domain/usecases/get_products.dart';
import 'setUp/service/signalr_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features

  // SignalR
  sl.registerSingleton<SignalRService>(SignalRService());

  // User
  sl.registerFactory(() => AuthBloc(
        signInUseCase: sl(),
        loadCurrentUserUseCase: sl(),
        signOutUseCase: sl(),
        updateAccessTokenUseCase: sl(),
      ));

  sl.registerFactory(() => ProductBloc(
        getProductUseCase: sl(),
        addNewProductUseCase: sl(),
        signalRService: sl(),
        productApprovalUseCase: sl(),
      ));

  sl.registerLazySingleton(() => ShopBloc(
        getShopUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => LoadCurrectUserUseCase(sl()));
  sl.registerLazySingleton(() => GetProductUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAccessTokenUseCase(sl()));
  sl.registerLazySingleton(() => ProductApprovalUseCase(sl()));
  sl.registerLazySingleton(() => AddNewProductUseCase(sl()));
  sl.registerLazySingleton(() => GetShopUseCase(sl()));

  // Repositories

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
        remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources - Remote
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ShopRemoteDataSource>(
    () => ShopRemoteDataSourceImpl(client: sl()),
  );

  // Data sources - Local
  // - User
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
