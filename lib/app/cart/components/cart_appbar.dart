import 'package:elkosh/app/cart/cart_cubit/cart_cubit.dart';
import 'package:elkosh/core/services/context_media.dart';
import 'package:elkosh/core/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.width,
        height: 70,
        decoration: BoxDecoration(
          color: ColorManager.primary.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 30.sp,
              color: Colors.white,
            ),
            const Spacer(),
            const Text(
              "سلة التسوق",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              padding: const EdgeInsets.only(left: 20),
              onPressed: () => context.read<CartCubit>().resetCart(),
              icon: Icon(
                Icons.cleaning_services_sharp,
                size: 26.sp,
              ),
            ),
          ],
        ));
  }
}
