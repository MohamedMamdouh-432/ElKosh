import 'package:auth_repository/auth_repository.dart';
import 'package:data_repository/data_repository.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          // todo: replace by MutliBlocProvider later
          child: const AppView(),
        );
      },
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: AppConstants.primaryColor.withOpacity(0.8),
    //     systemNavigationBarColor: AppConstants.primaryColor.withOpacity(0.6),
    //     statusBarIconBrightness: Brightness.dark,
    //     systemNavigationBarIconBrightness: Brightness.light,
    //   ),
    // );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: sl.get<SharedPreferences>().getBool('newToApp?')!
          ? RouteManager.onboardingRoute
          : RouteManager.signInRoute,
    );
  }
}
