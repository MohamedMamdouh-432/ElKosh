import 'package:elkosh/cart/screens/empty_bag_screen.dart';
import 'package:elkosh/cart/widgets/custom_cart_appbar.dart';
import 'package:elkosh/shared/dummy/dummy.dart';
import 'package:elkosh/shared/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/utils.dart';
import '../widgets/cart_listview.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: EmptyBageWidgetScreen(),
      body: Stack(
        children: [
          Column(
            children: [
              const CustomCartAppbar(),
              products.isEmpty
                  ? const EmptyBageWidgetScreen()
                  : const Cartlistview(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomButtom(
                  text: ' شـــراء',
                  ontap: () {
                    context.go(RouteManager.talabatyScreen);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
