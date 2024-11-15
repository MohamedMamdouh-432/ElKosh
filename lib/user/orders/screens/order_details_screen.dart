import 'package:elkosh/general/shared/functions.dart';
import 'package:elkosh/general/shared/services/context_media.dart';
import 'package:elkosh/general/shared/widgets/product_item_card.dart';
import 'package:elkosh/user/home/widgets/title_text.dart';
import 'package:elkosh/user/orders/bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:models_repository/models_repository.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final shopping = state.curOrder.shopping;
        return Scaffold(
          appBar: AppBar(
            title: Text(state.curOrder.marketName),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الطلب رقم # ${toArNumber(state.curOrder.code.toString())}",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'تاريخ الطلب: ${DateFormat("h:mm   yyyy / MM / dd").format(state.curOrder.createdAt)}',
                    textScaler: const TextScaler.linear(1.5),
                  ),
                  const Gap(10),
                  Text(
                    ' التكلفة الكليه: ${state.curOrder.total.toStringAsFixed(2)} جنيه',
                    textScaler: const TextScaler.linear(1.5),
                  ),
                  const Gap(10),
                  Visibility(
                    visible: state.curOrder.status == OrderStatus.cancelled ||
                        state.curOrder.status == OrderStatus.delivered,
                    child: Text(
                      state.curOrder.status == OrderStatus.cancelled
                          ? "تم إالغاء الطلب"
                          : "تم توصيل الطلب",
                      textScaler: const TextScaler.linear(1.5),
                    ),
                  ),
                  const Gap(10),
                  ExpansionTile(
                    title: const TitlesTextWidget(label: 'تفاصيل الطلب'),
                    children: List.generate(
                      state.curOrder.shopping.length,
                      (i) => ProductItemCard(
                        product: state.curOrder.shopping.keys.elementAt(i),
                        quantity: shopping.values.elementAt(i),
                        canEdit: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: state.curOrder.status == OrderStatus.pending ||
                state.curOrder.status == OrderStatus.shipped,
            child: SizedBox(
              width: context.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<OrdersBloc>()
                      .add(OrderCancellingEvent(state.curOrder.id));
                  context.pop();
                  context.read<OrdersBloc>().add(OrdersFetchedEvent());
                },
                child: const Text(
                  "إالغاء الطلب",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
