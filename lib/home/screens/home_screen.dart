import 'package:elkosh/core/utils/color_manager.dart';
import 'package:elkosh/home/components/ads_slider.dart';
import 'package:elkosh/home/components/custom_app_bar.dart';
import 'package:elkosh/home/components/markets_view.dart';
import 'package:elkosh/home/components/products_grid.dart';
import 'package:elkosh/home/controllers/ads_bloc/ads_bloc.dart';
import 'package:elkosh/home/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/home/controllers/products_bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
