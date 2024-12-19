import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/orders/bloc/orders_bloc.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:elkosh/shared/widgets/order_item_card.dart';
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
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                      'تاريخ الطلب: ${DateFormat("h:mm  yyyy/MM/dd").format(state.curOrder.createdAt)}',
                      textScaler: const TextScaler.linear(1.5),
                    ),
                  ),
                  const Gap(10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                          text: ' التكلفة الكليه:  ',
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
                    child: RichText(
                      text: TextSpan(
                          text: ' حالة الطلب:  ',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: state.curOrder.status == OrderStatus.pending
                                  ? "تم تسجيل الطلب"
                                  : "تم شحن الطلب",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: shopping.length,
                    itemBuilder: (context, i) => OrderItemCard(
                      product: shopping.keys.elementAt(i),
                      quantity: shopping.values.elementAt(i),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
