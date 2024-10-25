import 'package:elkosh/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EmptyCategorysView extends StatelessWidget {
  const EmptyCategorysView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/category.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          const Gap(10),
          Text(
            'كما ترى ليس هناك اى اصناف حتى الان ! يمكنك البدء و اضافة اول صنف فى المتجر الحالى',
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(20),
          ElevatedButton.icon(
            onPressed: () => context.push(RouteManager.addCategoryRoute),
            icon: const Icon(Icons.add, size: 28),
            label: const Text(
              'اضف اصناف الى المتجر الان',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
