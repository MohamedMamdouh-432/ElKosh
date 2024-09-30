import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/cart/screens/empty_bag_screen.dart';
import 'package:elkosh/cart/widgets/cart_card.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              AppBar(
                title: const Text("سلة التسوق"),
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_bag_outlined, size: 35),
                ),
                actions: [
                  IconButton(
                    padding: const EdgeInsets.only(left: 20),
                    onPressed: state.shopping.isEmpty
                        ? null
                        : () => context.read<CartBloc>().add(CartResetEvent()),
                    icon: const Icon(
                      Icons.cleaning_services_sharp,
                      size: 32,
                    ),
                  ),
                ],
              ),
              ConditionalBuilder(
                condition: state.shopping.isEmpty,
                builder: (context) => const EmptyBageWidgetScreen(),
                fallback: (context) => Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 60),
                    itemCount: state.shopping.length,
                    itemBuilder: (context, index) => CartItemCard(
                      product: state.shopping.keys.elementAt(index),
                      quantity: state.shopping.values.elementAt(index),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: 280.w,
            child: ElevatedButton(
              onPressed: state.shopping.isEmpty
                  ? null
                  : () => context.push(RouteManager.locationPickerRoute),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 5),
              ),
              child: const Text(
                "أطلب الأن",
                textScaler: TextScaler.linear(1.8),
              ),
            ),
          ),
        );
      },
    );
  }
}
