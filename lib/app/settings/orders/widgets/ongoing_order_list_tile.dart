import 'package:elkosh/app/settings/orders/bloc/orders_cubit.dart';
import 'package:elkosh/core/services/functions.dart';
import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/repos/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OngoingOrderListTile extends StatelessWidget {
  final UserOrder order;
  const OngoingOrderListTile({
    super.key,
    required this.order,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.read<OrdersCubit>().selectOrder(order);
        context.push(Routes.ongoingOrderDetailsRoute);
      },
      leading: CircleAvatar(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: FittedBox(
            child: Image.asset(
              Images.shoppingBasket,
              width: 70,
              height: 70,
            ),
          ),
        ),
      ),
      title: Text("رقم الطلب: ${toArNumber(order.code.toString())}"),
      subtitle: Text('السعر ${toArNumber((order.total + 10).toString())} جنيه'),
      trailing: Text(
        toArNumber(DateFormat("yyyy/MM/dd").format(order.createdAt)),
        textScaler: const TextScaler.linear(2),
      ),
    );
  }
}
