import 'package:elkosh/ads/components/ads_slider.dart';
import 'package:elkosh/ads/controllers/ads_cubit/ads_cubit.dart';
import 'package:elkosh/core/utils/color_manager.dart';
import 'package:elkosh/home/components/home_app_bar.dart';
import 'package:elkosh/markets/components/markets_view.dart';
import 'package:elkosh/markets/controllers/markets_cubit/markets_cubit.dart';
import 'package:elkosh/products/components/products_grid.dart';
import 'package:elkosh/products/controllers/products_cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../notifications/notific2/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Animation<double> appBarAnimation;
  late AnimationController appBarController;
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.getDeviceToken();
    notificationServices.requestNotificationPermission();
    notificationServices.initFirebaseNotification(context);
    notificationServices.setupInteractedMessage(context);
    //notificationServices.saveUserTokenToFirebase();
    appBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    appBarAnimation = Tween<double>(
      begin: 150,
      end: 80,
    ).animate(appBarController);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 60,
      color: ColorManager.primary,
      backgroundColor: Colors.white,
      notificationPredicate: (notification) => notification.depth <= 2,
      onRefresh: () async {
        Future.wait([
          Future.delayed(
            Duration.zero,
            () => context.read<AdsCubit>().loadAds(),
          ),
          Future.delayed(
            Duration.zero,
            () => context.read<MarketsCubit>().fetchMarkets(),
          ),
          Future.delayed(
            Duration.zero,
            () => context.read<ProductsCubit>().fetchProducts(),
          ),
        ]);
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            HomeAppBar(appBarAnimation: appBarAnimation),
            const AdsSlider(),
            const ProductsGrid(),
            const MarketsView(),
          ],
        ),
      ),
    );
  }
}
