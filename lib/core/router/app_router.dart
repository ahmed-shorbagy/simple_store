import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_store/features/auth/manager/auth_cubit.dart';
import 'package:simple_store/features/auth/views/login_view.dart';
import 'package:simple_store/features/auth/views/signup_view.dart';
import 'package:simple_store/features/cart/manager/cart_cubit.dart';
import 'package:simple_store/features/cart/repositories/cart_repository.dart';
import 'package:simple_store/features/home/manager/home_cubit.dart';
import 'package:simple_store/features/home/views/home_view.dart';
import 'package:simple_store/features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String kSplashView = '/';
  static const String kLoginView = '/login';
  static const String kRegisterView = '/register';
  static const String kHomeView = '/home';
  static const String kCartView = '/cart';

  static const String kSplashName = 'splash';
  static const String kLoginName = 'login';
  static const String kRegisterName = 'register';
  static const String kHomeName = 'home';
  static const String kCartName = 'cart';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.kSplashView,
  routes: [
    GoRoute(
      path: AppRoutes.kSplashView,
      name: AppRoutes.kSplashName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.kLoginView,
      name: AppRoutes.kLoginName,
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(),
        child: const LoginView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.kRegisterView,
      name: AppRoutes.kRegisterName,
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(),
        child: const SignupView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.kHomeView,
      name: AppRoutes.kHomeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeCubit(),
          ),
          BlocProvider(
            create: (context) => CartCubit(
              CartRepository(Dio()),
            ),
          ),
        ],
        child: const HomeView(),
      ),
    ),
  ],
);
