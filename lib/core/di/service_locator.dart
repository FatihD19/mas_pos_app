import 'package:get_it/get_it.dart';
import 'package:mas_pos_app/feature/category/data/datasource/category_remote_datasource.dart';
import 'package:mas_pos_app/feature/category/presentation/bloc/category_bloc.dart';
import 'package:mas_pos_app/feature/product/data/datasource/product_remote_datasource.dart';
import 'package:mas_pos_app/feature/product/data/datasource/product_local_datasource.dart';
import 'package:mas_pos_app/feature/product/presentation/bloc/product/product_bloc.dart';
import 'package:mas_pos_app/feature/product/presentation/bloc/cart/cart_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mas_pos_app/core/services/dio_client.dart';
import 'package:mas_pos_app/feature/auth/data/datasource/auth_local_datasource.dart';
import 'package:mas_pos_app/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:mas_pos_app/feature/auth/presentation/bloc/auth_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core
  sl.registerSingleton<DioClient>(DioClient(sharedPreferences));

  //Auth

  // Data sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(sl()),
  );

  // Blocs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      remoteDatasource: sl(),
      localDatasource: sl(),
    ),
  );

  //Product

  // Data sources
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(sl()),
  );

  // Local datasource untuk cart (singleton pattern sudah ada)
  sl.registerLazySingleton<ProductLocalDatasource>(
    () => ProductLocalDatasource.instance,
  );

  //Bloc
  sl.registerFactory<ProductBloc>(
    () => ProductBloc(remoteDatasource: sl()),
  );

  sl.registerFactory<CartBloc>(
    () => CartBloc(sl()),
  );

  //Category

  //Data sources
  sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(sl()));

  //Bloc
  sl.registerFactory<CategoryBloc>(
    () => CategoryBloc(remoteDataSource: sl()),
  );
}
