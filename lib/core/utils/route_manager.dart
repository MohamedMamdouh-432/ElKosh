import 'package:elkosh/screens/login_page.dart';
import 'package:elkosh/screens/register_Page.dart';
import 'package:go_router/go_router.dart';

abstract class RouteManager {
  static const String onboardingRoute = '/onboarding';
  static const String signInRoute = '/signIn';
  static const String signUpRoute = '/signUp';
  static const String homeRoute = '/home';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: signInRoute,
        builder: (context, state) => const SignInPage(),
      ),
    ],
  );
}
