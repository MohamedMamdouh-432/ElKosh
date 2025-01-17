import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/core/utils/route_manager.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class PlaceAdOrderBottomSheet extends StatelessWidget {
  final Ad ad;
  const PlaceAdOrderBottomSheet(this.ad, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تكلفة الطلب: \t\t\t${toArNumber(ad.total.toString())}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "مصاريف إضافيه: \t\t\t${toArNumber("10")}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("-------------------------------------------"),
              Text(
                "الإجمالى: \t\t\t${toArNumber((ad.total + 10).toString())}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.push(RouteManager.adDeliveryLocationPickerRoute),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    elevation: 15,
                  ),
                  icon: const Icon(CupertinoIcons.placemark),
                  label: const Text(
                    "تأكيد طلب العرض",
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
