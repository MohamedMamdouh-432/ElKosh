import 'package:elkosh/app/ads/controllers/ads_cubit/ads_cubit.dart';
import 'package:elkosh/app/auth/register/bloc/register_bloc.dart';
import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/app/home/controllers/nav_provider/nav_provider.dart';
import 'package:elkosh/app/home/markets/controllers/markets_cubit/markets_cubit.dart';
import 'package:elkosh/app/home/products/controllers/products_cubit/products_cubit.dart';
import 'package:elkosh/app/home/search/controllers/search_provider.dart';
import 'package:elkosh/app/settings/controllers/profile_provider.dart';
import 'package:elkosh/app/settings/orders/bloc/orders_cubit.dart';
import 'package:elkosh/core/theme/themes.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ElKoshApp extends StatelessWidget {
  const ElKoshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RegisterBloc()),
        BlocProvider(create: (_) => MarketsCubit()),
        BlocProvider(create: (_) => ProductsCubit()),
        BlocProvider(create: (_) => OrdersCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => AdsCubit()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => SearchProvider()),
        ],
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
      SystemUiOverlayStyle(
        statusBarColor: ColorManager.primary.withValues(),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: ColorManager.primary.withValues(alpha: 0.7),
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
          textTheme: GoogleFonts.tajawalTextTheme(),
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
