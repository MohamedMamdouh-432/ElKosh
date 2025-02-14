import 'package:elkosh/core/utils/color_manager.dart';
import 'package:elkosh/orders/bloc/orders_bloc.dart';
import 'package:elkosh/orders/widgets/order_card.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class HistoryOrderDetailsScreen extends StatelessWidget {
  const HistoryOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        final shopping = state.curOrder.shopping;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 247, 234, 250),
                Color.fromARGB(255, 250, 240, 236),
                Color.fromARGB(255, 235, 244, 251),
                Color.fromARGB(255, 246, 237, 233),
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Gap(30),
                    Text(
                      "الطلب رقم # ${toArNumber(state.curOrder.code.toString())}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'تاريخ الطلب: ${toArNumber(DateFormat("h:mm  yyyy/MM/dd").format(state.curOrder.createdAt))}',
                        textScaler: const TextScaler.linear(1.5),
                      ),
                    ),
                    const Gap(10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                            text: ' إجمالى التكلفة:  ',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${toArNumber((state.curOrder.total).toStringAsFixed(2))} جنيه',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const Gap(10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Text(
                            ' حالة الطلب:  ',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: state.curOrder.color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              state.curOrder.content,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                            text: ' موقع التوصيل:  ',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: state.curOrder.location.address,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            endIndent: 10,
                            thickness: 2,
                            color: ColorManager.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: ColorManager.primary),
                          ),
                          child: const Text(
                            "سلة المشتريات",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            indent: 10,
                            thickness: 2,
                            color: ColorManager.primary,
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: shopping.length,
                      itemBuilder: (context, i) => OrderCard(
                        isAd: state.curOrder.isAd,
                        shoppingItem: shopping[i],
                      ),
                      separatorBuilder: (context, index) => const Gap(10),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
