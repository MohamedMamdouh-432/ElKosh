import 'package:elkosh/app/ads/components/ads_slider.dart';
import 'package:elkosh/app/ads/controllers/ads_cubit/ads_cubit.dart';
import 'package:elkosh/app/home/components/home_appbar.dart';
import 'package:elkosh/app/home/markets/components/markets_view.dart';
import 'package:elkosh/app/home/markets/controllers/markets_cubit/markets_cubit.dart';
import 'package:elkosh/app/home/products/components/products_grid.dart';
import 'package:elkosh/app/home/products/controllers/products_cubit/products_cubit.dart';
import 'package:elkosh/core/theme/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../notifications/notific2/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
            () => context.read<AdsCubit>().fetchAds(),
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
      child: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            HomeAppBar(),
            AdsSlider(),
            ProductsGrid(),
            MarketsView(),
          ],
        ),
      ),
    );
  }
}
