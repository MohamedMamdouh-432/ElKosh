import 'package:elkosh/cart/bloc/cart_bloc.dart';
import 'package:elkosh/core/utils/route_manager.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';

class PlaceAdOrderBottomSheet extends StatelessWidget {
  final Ad ad;
  const PlaceAdOrderBottomSheet(this.ad, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 15.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تكلفة الطلب: \t\t\t${toArNumber(ad.total.toString())}",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "مصاريف إضافيه: \t\t\t${toArNumber("10")}",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("-------------------------------------------"),
              Text(
                "الإجمالى: \t\t\t${toArNumber((ad.total + 10).toString())}",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(20.sp),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.push(RouteManager.adDeliveryLocationPickerRoute),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40.sp),
                    elevation: 10.sp,
                  ),
                  icon: const Icon(CupertinoIcons.placemark),
                  label: Text(
                    "تأكيد طلب العرض",
                    style: TextStyle(
                      fontSize: 10.sp,
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
