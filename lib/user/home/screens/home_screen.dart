import 'package:elkosh/general/core/utils/color_manager.dart';
import 'package:elkosh/user/home/components/custom_app_bar.dart';
import 'package:elkosh/user/home/components/markets_view.dart';
import 'package:elkosh/user/home/components/products_grid.dart';
import 'package:elkosh/user/home/components/slider.dart';
import 'package:elkosh/user/home/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/user/home/controllers/products_bloc/products_bloc.dart';
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
      onRefresh: () async {
        context.read<MarketsBloc>().add(const MarketsLoadingEvent());
        context.read<ProductsBloc>().add(const ProductsLoadingEvent());
      },
      child: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(),
            ProductsSlider(),
            ProductsGrid(),
            MarketsView(),
          ],
        ),
      ),
    );
  }
}
