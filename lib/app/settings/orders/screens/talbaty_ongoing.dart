import 'package:elkosh/app/settings/orders/bloc/orders_cubit.dart';
import 'package:elkosh/app/settings/orders/widgets/ongoing_order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:models_repository/models_repository.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class TalbatyOngoing extends StatefulWidget {
  const TalbatyOngoing({super.key});
  @override
  State<TalbatyOngoing> createState() => _TalbatyOngoingState();
}

class _TalbatyOngoingState extends State<TalbatyOngoing> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_isBottom) context.read<OrdersCubit>().fetchOngoingOrders();
    });
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      buildWhen: (p, c) => p != c,
      listenWhen: (p, c) => p != c,
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
              context.read<OrdersCubit>().fetchOngoingOrders();
            },
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.status == OrdersStatus.onProgress,
          child: ListView.builder(
            itemCount: state.ongoingOrders.length,
            controller: _scrollController,
            itemBuilder: (ctx, index) => OngoingOrderListTile(
              order: state.ongoingOrders[index],
            ),
          ),
        );
      },
    );
  }
}
