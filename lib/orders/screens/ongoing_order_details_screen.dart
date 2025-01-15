import 'package:elkosh/orders/bloc/orders_bloc.dart';
import 'package:elkosh/orders/widgets/order_card.dart';
import 'package:elkosh/orders/widgets/order_section.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:models_repository/models_repository.dart';

class OngoingOrderDetailsScreen extends StatelessWidget {
  const OngoingOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
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
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${toArNumber((state.curOrder.total).toStringAsFixed(2))} جنيه',
                                style: TextStyle(
                                  fontSize: 18.sp,
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
                              fontSize: 18.sp,
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
                              state.curOrder.status == OrderStatus.pending
                                  ? "تم تسجيل الطلب"
                                  : "تم شحن الطلب",
                              style: TextStyle(
                                fontSize: 15.sp,
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
                              fontSize: 18.sp,
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
                    const OrderSection(sectionTitle: "سلة المشتريات"),
                    const Gap(20),
                    ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: context.width * 0.8,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<OrdersBloc>()
                            .add(OrderDeleveringingEvent(state.curOrder));
                        context.pop();
                      },
                      child: const Text(
                        "إستلام",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<OrdersBloc>()
                            .add(OrderCancellingEvent(state.curOrder));
                        context.pop();
                      },
                      child: const Text(
                        "إلغاء",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<OrdersBloc>()
                            .add(OrderRefusingEvent(state.curOrder));
                        context.pop();
                      },
                      child: const Text(
                        "رفض الاستلام",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
