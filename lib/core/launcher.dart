import 'package:elkosh/auth/register/bloc/register_bloc.dart';
import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/ads/controllers/ad_details_bloc/ad_details_bloc.dart';
import 'package:elkosh/ads/controllers/ads_bloc/ads_bloc.dart';
import 'package:elkosh/markets/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/products/controllers/products_bloc/products_bloc.dart';
import 'package:elkosh/orders/bloc/orders_bloc.dart';
import 'package:elkosh/search/bloc/search_bloc.dart';
import 'package:elkosh/settings/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ElKoshApp extends StatelessWidget {
  const ElKoshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RegisterBloc()),
        BlocProvider(create: (_) => MarketsBloc()),
        BlocProvider(create: (_) => ProductsBloc()),
        BlocProvider(create: (_) => ProfileBloc()),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => OrdersBloc()),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => AdsBloc()),
        BlocProvider(create: (_) => AdDetailsBloc()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => NavProvider(),
        child: const ElKoshLauncher(),
      ),
    );
  }
}

class ElKoshLauncher extends StatelessWidget {
  const ElKoshLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 247, 234, 250),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color.fromARGB(255, 246, 237, 233),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Color.fromARGB(255, 246, 237, 233),
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
