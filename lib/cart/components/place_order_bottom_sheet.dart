import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/core/utils/route_manager.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PlaceOrderBottomSheet extends StatelessWidget {
  const PlaceOrderBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: context.bottomInsets + 10.sp,
      ),
      child: BlocBuilder<CartBloc, CartState>(
        buildWhen: (p, c) => p != c,
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(15),
              Text(
                "تكلفة الطلب: \t\t\t${toArNumber(state.price.toString())}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "رسوم توصيل: \t\t\t${toArNumber("10")}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("-------------------------------------------"),
              Text(
                "الإجمالى: \t\t\t${toArNumber((state.price + 10).toString())}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.push(RouteManager.deliveryLocationPickerRoute),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    elevation: 15,
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.done_all, size: 25),
                  label: Text(
                    "تأكيد الطلب",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
