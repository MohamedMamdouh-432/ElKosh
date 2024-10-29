import 'package:elkosh/seller/controllers/orders_bloc/seller_orders_bloc.dart';
import 'package:elkosh/user/cart/bloc/cart_bloc.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/user/home/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/user/home/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/user/orders/bloc/orders_bloc.dart';
import 'package:elkosh/seller/controllers/category_bloc/seller_category_bloc.dart';
import 'package:elkosh/seller/controllers/market_form_bloc/market_form_bloc.dart';
import 'package:elkosh/seller/controllers/markets_bloc/seller_markets_bloc.dart';
import 'package:elkosh/seller/controllers/product_form_bloc/product_form_bloc.dart';
import 'package:elkosh/seller/controllers/products_bloc/seller_products_bloc.dart';
import 'package:elkosh/settings/bloc/profile_bloc.dart';
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
        BlocProvider<SellerMarketsBloc>(create: (_) => SellerMarketsBloc()),
        BlocProvider<MarketFormBloc>(create: (_) => MarketFormBloc()),
        BlocProvider<SellerCategoryBloc>(create: (_) => SellerCategoryBloc()),
        BlocProvider<SellerProductsBloc>(create: (_) => SellerProductsBloc()),
        BlocProvider<ProductFormBloc>(create: (_) => ProductFormBloc()),
        BlocProvider<SellerOrdersBloc>(create: (_) => SellerOrdersBloc()),
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
