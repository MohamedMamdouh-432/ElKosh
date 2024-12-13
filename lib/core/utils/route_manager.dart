import 'package:elkosh/auth/login/bloc/login_bloc.dart';
import 'package:elkosh/auth/login/screens/login_screen.dart';
import 'package:elkosh/auth/register/screens/opt_screen.dart';
import 'package:elkosh/auth/register/screens/register_screen.dart';
import 'package:elkosh/cart/screens/delivery_location_picker_screen.dart';
import 'package:elkosh/home/screens/home_screen.dart';
import 'package:elkosh/home/screens/market_details_screen.dart';
import 'package:elkosh/home/screens/navbar_screen.dart';
import 'package:elkosh/home/screens/product_details_screen.dart';
import 'package:elkosh/home/screens/products_screen.dart';
import 'package:elkosh/orders/screens/order_details_screen.dart';
import 'package:elkosh/orders/screens/talabty_screen.dart';
import 'package:elkosh/search/screens/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class RouteManager {
  static const String loginRoute = '/';
  static const String registerRoute = '/register';
  static const String optRoute = '/opt';
  static const String navbarRoute = '/navbar';
  static const String homeRoute = '/home';
  static const String searchRoute = '/search';
  static const String productDetailsRoute = '/product_details';
  static const String productsRoute = '/products';
  static const String marketDetailsRoute = '/market_details';
  static const String talabatyScreen = '/talabaty';
  static const String deliveryLocationPickerRoute = '/delivery_location_picker';
  static const String orderDetailsRoute = '/order_details';

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: talabatyScreen,
        builder: (context, state) => const TalabtyScreen(),
      ),
      GoRoute(
        path: registerRoute,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: optRoute,
        builder: (context, state) => const OptScreen(),
      ),
      GoRoute(
        path: loginRoute,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginBloc()..add(LoginRecognizeRequested()),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: navbarRoute,
        builder: (context, state) => const NavBarScreen(),
      ),
      GoRoute(
        path: homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: searchRoute,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: productDetailsRoute,
        builder: (context, state) => const ProductDetailsScreen(),
      ),
      GoRoute(
        path: productsRoute,
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: marketDetailsRoute,
        builder: (context, state) => const MarkettDetailsScreen(),
      ),
      GoRoute(
        path: deliveryLocationPickerRoute,
        builder: (context, state) => const DeliveryLocationPickerScreen(),
      ),
      GoRoute(
        path: orderDetailsRoute,
        builder: (context, state) => const OrderDetailsScreen(),
      ),
    ],
  );
}
