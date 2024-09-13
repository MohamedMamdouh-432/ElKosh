import 'package:elkosh/auth/login/screens/login_page.dart';
import 'package:elkosh/auth/register/screens/register_screen.dart';
import 'package:elkosh/home/screens/home_page.dart';
import 'package:go_router/go_router.dart';

abstract class RouteManager {
  static const String registerRoute = '/';
  static const String loginRoute = '/signUp';
  static const String homeRoute = '/home';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: registerRoute,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: loginRoute,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: homeRoute,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
