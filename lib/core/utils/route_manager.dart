import 'package:elkosh/auth/login/screens/login_screen.dart';
import 'package:elkosh/auth/register/screens/register_screen.dart';
import 'package:elkosh/home/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

abstract class RouteManager {
  static const String registerRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: registerRoute,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
