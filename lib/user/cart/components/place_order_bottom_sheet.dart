import 'package:elkosh/user/cart/bloc/cart_bloc.dart';
import 'package:elkosh/core/utils/route_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PlaceOrderBottomSheet extends StatelessWidget {
  const PlaceOrderBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "اسم المتجر : \t\t${state.marketName}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(15),
              Text(
                "تكلفة الطلب: \t\t\t${state.price}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "مصاريف إضافيه: \t\t\t${(state.price / 100).ceil()}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("-------------------------------------------"),
              Text(
                "الإجمالى: \t\t\t${state.price + ((state.price / 100).ceil())}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.push(RouteManager.deliveryLocationPickerRoute),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    elevation: 15,
                  ),
                  icon: const Icon(CupertinoIcons.placemark),
                  label: const Text(
                    "تأكيد الطلب",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
