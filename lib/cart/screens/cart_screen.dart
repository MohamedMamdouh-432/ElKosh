import 'package:elkosh/cart/screens/empty_bag_screen.dart';
import 'package:elkosh/cart/widgets/custom_cart_appbar.dart';
import 'package:flutter/material.dart';
import 'package:models_repository/models_repository.dart';

import '../widgets/cart_listview.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> products = [];
    return Scaffold(
      // body: EmptyBageWidgetScreen(),
      body: Column(
        children: [
          const CustomCartAppbar(),
          products.isEmpty
              ? const EmptyBageWidgetScreen()
              : const cartlistview(),
        ],
      ),
    );
  }
}
