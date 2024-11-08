import 'package:elkosh/admin/controllers/category_bloc/admin_category_bloc.dart';
import 'package:elkosh/admin/controllers/market_form_bloc/market_form_bloc.dart';
import 'package:elkosh/admin/controllers/markets_bloc/admin_markets_bloc.dart';
import 'package:elkosh/admin/controllers/orders_bloc/admin_orders_bloc.dart';
import 'package:elkosh/admin/controllers/product_form_bloc/product_form_bloc.dart';
import 'package:elkosh/admin/controllers/products_bloc/admin_products_bloc.dart';
import 'package:elkosh/general/core/utils/utils.dart';
import 'package:elkosh/general/settings/bloc/profile_bloc.dart';
import 'package:elkosh/user/cart/bloc/cart_bloc.dart';
import 'package:elkosh/user/home/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/user/home/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/user/orders/bloc/orders_bloc.dart';
import 'package:elkosh/user/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElKoshApp extends StatelessWidget {
  const ElKoshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MarketsBloc>(create: (_) => MarketsBloc()),
        BlocProvider<ProductsBloc>(create: (_) => ProductsBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<CartBloc>(create: (_) => CartBloc()),
        BlocProvider<OrdersBloc>(create: (_) => OrdersBloc()),
        BlocProvider<AdminMarketsBloc>(create: (_) => AdminMarketsBloc()),
        BlocProvider<MarketFormBloc>(create: (_) => MarketFormBloc()),
        BlocProvider<AdminCategoryBloc>(create: (_) => AdminCategoryBloc()),
        BlocProvider<AdminProductsBloc>(create: (_) => AdminProductsBloc()),
        BlocProvider<ProductFormBloc>(create: (_) => ProductFormBloc()),
        BlocProvider<AdminOrdersBloc>(create: (_) => AdminOrdersBloc()),
        BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
      ],
      child: const ElKoshLauncher(),
    );
  }
}

class ElKoshLauncher extends StatelessWidget {
  const ElKoshLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xffFFF9F6),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(320, 690),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: RouteManager.router,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xffFF6100),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xffFF6100),
          ),
        ),
        supportedLocales: const [Locale('ar', '')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('ar', ''),
      ),
    );
  }
}
