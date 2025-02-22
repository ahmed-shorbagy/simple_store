import 'package:go_router/go_router.dart';
import 'package:simple_store/features/auth/views/login_screen.dart';
import 'package:simple_store/features/auth/views/register_screen.dart';
import 'package:simple_store/features/cart/views/cart_screen.dart';
import 'package:simple_store/features/home/views/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
  ],
);
