import 'package:elkosh/app/settings/orders/bloc/orders_cubit.dart';
import 'package:elkosh/app/settings/orders/widgets/order_ad_card.dart';
import 'package:elkosh/app/settings/orders/widgets/order_item_card.dart';
import 'package:elkosh/app/settings/orders/widgets/order_section.dart';
import 'package:elkosh/app/settings/orders/widgets/order_selector.dart';
import 'package:elkosh/core/services/context_media.dart';
import 'package:elkosh/core/services/functions.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class OngoingOrderDetailsScreen extends StatelessWidget {
  const OngoingOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
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
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 80),
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
                                    '${toArNumber((state.curOrder.total + 10).toStringAsFixed(2))} جنيه',
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
                                fontSize: 13.sp,
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
                    OrderSection(sectionTitle: 'سلة التسوق'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 20,
                        children: [
                          Visibility(
                            visible: state.curOrder.items.isNotEmpty,
                            child: ExpandablePanel(
                              header: const Text('المشتريات',
                                  textScaler: TextScaler.linear(1.5)),
                              collapsed: const SizedBox(),
                              expanded: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: Column(
                                  spacing: 5,
                                  children: state.curOrder.items.entries
                                      .map((entry) => OrderItemCard(entry))
                                      .toList(),
                                ),
                              ),
                              theme: const ExpandableThemeData(
                                headerAlignment:
                                    ExpandablePanelHeaderAlignment.center,
                                tapBodyToExpand: true,
                                tapBodyToCollapse: true,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: state.curOrder.ads.isNotEmpty,
                            child: ExpandablePanel(
                              header: const Text('العروض',
                                  textScaler: TextScaler.linear(1.5)),
                              collapsed: const SizedBox(),
                              expanded: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: Column(
                                  spacing: 5,
                                  children: state.curOrder.ads.entries
                                      .map((entry) => OrderAdCard(entry))
                                      .toList(),
                                ),
                              ),
                              theme: const ExpandableThemeData(
                                headerAlignment:
                                    ExpandablePanelHeaderAlignment.center,
                                tapBodyToExpand: true,
                                tapBodyToCollapse: true,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                  OrderSelector(
                    content: 'إستلام',
                    onTap: () => context
                        .read<OrdersCubit>()
                        .deliverOrder(state.curOrder),
                  ),
                  const Gap(10),
                  OrderSelector(
                    content: 'إالغاء',
                    onTap: () =>
                        context.read<OrdersCubit>().cancelOrder(state.curOrder),
                  ),
                  const Gap(10),
                  OrderSelector(
                    content: 'رفض',
                    onTap: () =>
                        context.read<OrdersCubit>().refuseOrder(state.curOrder),
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
