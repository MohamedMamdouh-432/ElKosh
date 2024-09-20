import 'package:elkosh/auth/login/screens/login_screen.dart';
import 'package:elkosh/auth/register/screens/register_screen.dart';
import 'package:elkosh/home/screens/navbar_screen.dart';
import 'package:elkosh/search/screens/search_screen.dart';
import 'package:go_router/go_router.dart';

abstract class RouteManager {
  static const String registerRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String searchRoute = '/search';

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
        builder: (context, state) => const NavBarScreen(),
      ),
      GoRoute(
        path: searchRoute,
        builder: (context, state) => const SearchScreen(),
      ),
    ],
  );
}
