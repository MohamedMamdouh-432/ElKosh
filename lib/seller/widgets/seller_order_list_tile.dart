import 'package:elkosh/core/utils/utils.dart';
import 'package:elkosh/seller/controllers/orders_bloc/seller_orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:models_repository/models_repository.dart';

class SellerOrderListTile extends StatelessWidget {
  final UserOrder order;
  const SellerOrderListTile({
    super.key,
    required this.order,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.read<SellerOrdersBloc>().add(SellerOrderSelectedEvent(order));
        context.push(RouteManager.orderDetailsRoute);
      },
      leading: CircleAvatar(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: FittedBox(
            child: Image.asset(
              ImageManager.shoppingBasket,
              width: 70,
              height: 70,
            ),
          ),
        ),
      ),
      title: Text(order.marketName),
      subtitle: Text('السعر ${order.total} جنيه'),
      trailing: Text(DateFormat("yyyy-MM-dd").format(order.createdAt)),
    );
  }
}
