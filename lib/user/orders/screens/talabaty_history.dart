import 'package:elkosh/user/orders/bloc/orders_bloc.dart';
import 'package:elkosh/user/orders/widgets/order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';

class TalabatyHistory extends StatelessWidget {
  const TalabatyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.status == OrdersStatus.onProgress,
          child: ListView.builder(
            itemCount: state.historyOrders.length,
            itemBuilder: (ctx, index) => OrderListTile(
              order: state.historyOrders[index],
            ),
          ),
        );
      },
    );
  }
}
