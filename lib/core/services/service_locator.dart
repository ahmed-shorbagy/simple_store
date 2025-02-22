import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/cart/cubits/cart_cubit.dart';
import '../../features/home/cubits/home_cubit.dart';
import '../../features/home/repositories/home_repository.dart';
import 'api_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  sl.registerLazySingleton(() => ApiService());
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefs);

  // Repositories
  sl.registerLazySingleton(() => HomeRepository());

  // Cubits
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepository>()));
  sl.registerLazySingleton<CartCubit>(() => CartCubit());

  // ViewModels will be registered here when we create the features
}
