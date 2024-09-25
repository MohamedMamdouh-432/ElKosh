import 'package:elkosh/home/components/markets_view.dart';
import 'package:elkosh/home/components/products_grid.dart';
import 'package:elkosh/home/components/custom_app_bar.dart';
import 'package:elkosh/home/components/slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(),
          ProductsSlider(),
          ProductsGrid(),
          MarketsView(),
        ],
      ),
    );
  }
}
