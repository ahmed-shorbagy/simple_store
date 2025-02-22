import 'package:get_it/get_it.dart';

import '../../features/auth/cubits/auth_cubit.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/cart/cubits/cart_cubit.dart';
import '../../features/home/cubits/home_cubit.dart';
import '../../features/home/repositories/home_repository.dart';
import 'api_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton<ApiService>(() => ApiService());

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  locator.registerLazySingleton<HomeRepository>(() => HomeRepository());

  // Cubits
  locator
      .registerFactory<AuthCubit>(() => AuthCubit(locator<AuthRepository>()));
  locator
      .registerFactory<HomeCubit>(() => HomeCubit(locator<HomeRepository>()));
  locator.registerLazySingleton<CartCubit>(() => CartCubit());

  // ViewModels will be registered here when we create the features
}
