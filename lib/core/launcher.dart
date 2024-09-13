import 'package:auth_repository/auth_repository.dart';
import 'package:data_repository/data_repository.dart';
import 'package:elkosh/auth/register/bloc/register_bloc.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_repository/user_repository.dart';

class ElKoshApp extends StatelessWidget {
  const ElKoshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(320, 690),
      builder: (context, child) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: sl.get<DataRepository>()),
            RepositoryProvider.value(value: sl.get<AuthRepository>()),
            RepositoryProvider.value(value: sl.get<UserRepository>()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => RegisterBloc()),
            ],
            child: const AppView(),
          ),
        );
      },
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    return MaterialApp.router(
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
    );
  }
}
