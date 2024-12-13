import 'package:elkosh/orders/bloc/orders_bloc.dart';
import 'package:elkosh/orders/widgets/order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class TalbatyOngoing extends StatelessWidget {
  const TalbatyOngoing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state.status == OrdersStatus.fetchFailure) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'خطأ',
            text: 'حدث خطأ أثناء تحميل الطلبات',
            borderRadius: 25,
            barrierDismissible: false,
            confirmBtnText: "أعد المحاولة",
            onConfirmBtnTap: () {
              context.pop();
              context.read<OrdersBloc>().add(OrdersFetchedEvent());
            },
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.status == OrdersStatus.onProgress,
          child: ListView.builder(
            itemCount: state.ongoingOrders.length,
            itemBuilder: (ctx, index) => OrderListTile(
              order: state.ongoingOrders[index],
            ),
          ),
        );
      },
    );
  }
}
