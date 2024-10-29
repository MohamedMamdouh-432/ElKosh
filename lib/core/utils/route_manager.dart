import 'package:elkosh/auth/login/bloc/login_bloc.dart';
import 'package:elkosh/auth/login/screens/login_screen.dart';
import 'package:elkosh/auth/register/bloc/register_bloc.dart';
import 'package:elkosh/auth/register/screens/register_screen.dart';
import 'package:elkosh/seller/forms/add_category.dart';
import 'package:elkosh/seller/forms/add_market.dart';
import 'package:elkosh/seller/forms/add_product.dart';
import 'package:elkosh/seller/forms/edit_market.dart';
import 'package:elkosh/seller/forms/edit_product.dart';
import 'package:elkosh/seller/screens/categorys_screen.dart';
import 'package:elkosh/seller/screens/market_location_picker_screen.dart';
import 'package:elkosh/seller/screens/markets_page.dart';
import 'package:elkosh/seller/screens/product_details_screen.dart';
import 'package:elkosh/seller/screens/products_screen.dart';
import 'package:elkosh/seller/screens/seller_screen.dart';
import 'package:elkosh/user/cart/screens/delivery_location_picker_screen.dart';
import 'package:elkosh/user/home/screens/home_screen.dart';
import 'package:elkosh/user/home/screens/market_details_screen.dart';
import 'package:elkosh/user/home/screens/navbar_screen.dart';
import 'package:elkosh/user/home/screens/product_details_screen.dart';
import 'package:elkosh/user/home/screens/products_screen.dart';
import 'package:elkosh/user/orders/screens/order_details_screen.dart';
import 'package:elkosh/user/orders/screens/talabty_screen.dart';
import 'package:elkosh/user/search/screens/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class RouteManager {
  static const String loginRoute = '/';
  static const String registerRoute = '/register';
  static const String navbarRoute = '/navbar';
  static const String homeRoute = '/home';
  static const String searchRoute = '/search';
  static const String productDetailsRoute = '/product_details';
  static const String productsRoute = '/products';
  static const String marketDetailsRoute = '/market_details';
  static const String talabatyScreen = '/talabaty';
  static const String deliveryLocationPickerRoute = '/delivery_location_picker';
  static const String orderDetailsRoute = '/order_details';
  static const String sellerRoute = '/seller';
  static const String sellerMarketsRoute = '/seller_markets';
  static const String addMarketRoute = '/add_market';
  static const String editMarketRoute = '/edit_market';
  static const String marketLocationPickerRoute = '/market_location_picker';
  static const String sellerCategorysRoute = '/seller_categories';
  static const String addCategoryRoute = '/add_category';
  static const String sellerProductsRoute = '/seller_products';
  static const String addProductRoute = '/add_product';
  static const String editProductRoute = '/edit_product';
  static const String sellerProductDetailsRoute = '/seller_product_details';

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: talabatyScreen,
        builder: (context, state) => const TalabtyScreen(),
      ),
      GoRoute(
        path: registerRoute,
        builder: (context, state) => BlocProvider(
          create: (context) => RegisterBloc(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: loginRoute,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginBloc(),
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
      GoRoute(
        path: sellerRoute,
        builder: (context, state) => const SellerScreen(),
      ),
      GoRoute(
        path: sellerMarketsRoute,
        builder: (context, state) => const MarketsPage(),
      ),
      GoRoute(
        path: addMarketRoute,
        builder: (context, state) => const AddMarketForm(),
      ),
      GoRoute(
        path: editMarketRoute,
        builder: (context, state) => const EditMarketForm(),
      ),
      GoRoute(
        path: marketLocationPickerRoute,
        builder: (context, state) => const MarketLocationPickerScreen(),
      ),
      GoRoute(
        path: sellerCategorysRoute,
        builder: (context, state) => const CategorysScreen(),
      ),
      GoRoute(
        path: addCategoryRoute,
        builder: (context, state) => const AddCategoryForm(),
      ),
      GoRoute(
        path: sellerProductsRoute,
        builder: (context, state) => const SellerProductsScreen(),
      ),
      GoRoute(
        path: addProductRoute,
        builder: (context, state) => const AddProductForm(),
      ),
      GoRoute(
        path: editProductRoute,
        builder: (context, state) => const EditProductForm(),
      ),
      GoRoute(
        path: sellerProductDetailsRoute,
        builder: (context, state) => const SellerProductDetailsScreen(),
      ),
    ],
  );
}
