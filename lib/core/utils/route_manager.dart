import 'package:elkosh/ads/screens/ad_delivery_location_picker_screen.dart';
import 'package:elkosh/ads/screens/ad_details_screen.dart';
import 'package:elkosh/auth/login/bloc/login_bloc.dart';
import 'package:elkosh/auth/login/screens/login_screen.dart';
import 'package:elkosh/auth/register/screens/otp_screen.dart';
import 'package:elkosh/auth/register/screens/register_screen.dart';
import 'package:elkosh/cart/screens/delivery_location_picker_screen.dart';
import 'package:elkosh/home/screens/home_screen.dart';
import 'package:elkosh/home/screens/navbar_screen.dart';
import 'package:elkosh/markets/screens/market_details_screen.dart';
import 'package:elkosh/orders/screens/history_order_details_screen.dart';
import 'package:elkosh/orders/screens/ongoing_order_details_screen.dart';
import 'package:elkosh/orders/screens/talabty_screen.dart';
import 'package:elkosh/products/screens/product_details_screen.dart';
import 'package:elkosh/products/screens/products_screen.dart';
import 'package:elkosh/search/screens/search_screen.dart';
import 'package:elkosh/settings/screens/about_app_screen.dart';
import 'package:elkosh/settings/screens/app_policy2.dart';
import 'package:elkosh/settings/screens/privacy_policy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class RouteManager {
  static const String loginRoute = '/';
  static const String registerRoute = '/register';
  static const String otpRoute = '/opt';
  static const String navbarRoute = '/navbar';
  static const String homeRoute = '/home';
  static const String searchRoute = '/search';
  static const String productDetailsRoute = '/product_details';
  static const String productsRoute = '/products';
  static const String marketDetailsRoute = '/market_details';
  static const String talabatyScreen = '/talabaty';
  static const String deliveryLocationPickerRoute = '/delivery_location_picker';
  static const String ongoingOrderDetailsRoute = '/ongoing_order_details';
  static const String historyOrderDetailsRoute = '/history_order_details';
  static const String adDetailsRoute = '/ad_details';
  static const String aboutAppRoute = '/about_app';
  static const String adDeliveryLocationPickerRoute =
      '/ad_delivery_location_picker';
  static const String privacyPolicyRoute = '/privacy_policy';
  static const String privacyPolicyRoute2 = '/privacy_policy2';

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: talabatyScreen,
        builder: (_, __) => const TalabtyScreen(),
      ),
      GoRoute(
        path: privacyPolicyRoute2,
        builder: (_, __) => const AppIntroductionPage(),
      ),
      GoRoute(
        path: privacyPolicyRoute,
        builder: (_, __) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: registerRoute,
        builder: (_, __) => RegisterScreen(),
      ),
      GoRoute(
        path: otpRoute,
        builder: (_, __) => const OtpScreen(),
      ),
      GoRoute(
        path: loginRoute,
        builder: (_, __) => BlocProvider(
          create: (___) => LoginBloc()..add(LoginRecognizeRequested()),
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: navbarRoute,
        builder: (_, __) => const NavBarScreen(),
      ),
      GoRoute(
        path: homeRoute,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: searchRoute,
        builder: (_, __) => const SearchScreen(),
      ),
      GoRoute(
        path: productDetailsRoute,
        builder: (_, __) => const ProductDetailsScreen(),
      ),
      GoRoute(
        path: productsRoute,
        builder: (_, __) => const ProductsScreen(),
      ),
      GoRoute(
        path: marketDetailsRoute,
        builder: (_, __) => const MarkettDetailsScreen(),
      ),
      GoRoute(
        path: deliveryLocationPickerRoute,
        builder: (_, __) => DeliveryLocationPickerScreen(),
      ),
      GoRoute(
        path: ongoingOrderDetailsRoute,
        builder: (_, __) => const OngoingOrderDetailsScreen(),
      ),
      GoRoute(
        path: historyOrderDetailsRoute,
        builder: (_, __) => const HistoryOrderDetailsScreen(),
      ),
      GoRoute(
        path: adDetailsRoute,
        builder: (_, __) => const AdDetailsScreen(),
      ),
      GoRoute(
        path: aboutAppRoute,
        builder: (_, __) => const AboutAppScreen(),
      ),
      GoRoute(
        path: adDeliveryLocationPickerRoute,
        builder: (_, __) => const AdDeliveryLocationPickerScreen(),
      ),
    ],
  );
}
