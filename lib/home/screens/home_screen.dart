import 'package:elkosh/core/utils/color_manager.dart';
import 'package:elkosh/ads/components/ads_slider.dart';
import 'package:elkosh/home/components/custom_app_bar.dart';
import 'package:elkosh/markets/components/markets_view.dart';
import 'package:elkosh/products/components/products_grid.dart';
import 'package:elkosh/ads/controllers/ads_bloc/ads_bloc.dart';
import 'package:elkosh/markets/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/products/controllers/products_bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../notifications/notific2/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            () => context.read<AdsBloc>().add(AdsLoadingEvent()),
          ),
          Future.delayed(
            Duration.zero,
            () => context.read<MarketsBloc>().add(MarketsLoadingEvent()),
          ),
          Future.delayed(
            Duration.zero,
            () => context
                .read<ProductsBloc>()
                .add(const ProductsLoadingEvent(10)),
          ),
          Future.delayed(
            Duration.zero,
            () => context
                .read<ProductsBloc>()
                .add(const ProductsLoadingEvent()),
          ),
        ]);
      },
      child: const SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(),
            AdsSlider(),
            ProductsGrid(),
            MarketsView(),
          ],
        ),
      ),
    );
  }
}
