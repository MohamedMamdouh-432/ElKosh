import 'dart:async';

import 'package:admin_repository/admin_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'admin_orders_event.dart';
part 'admin_orders_state.dart';

class AdminOrdersBloc extends Bloc<AdminOrdersEvent, AdminOrdersState> {
  AdminOrdersBloc() : super(AdminOrdersState.initial) {
    on<AdminOrdersFetchedEvent>(_onOrdersFetched);
    on<AdminOrderSelectedEvent>(_onOrderSelected);
    add(AdminOrdersFetchedEvent());
  }

  Future<void> _onOrdersFetched(event, emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final orders = await sl.get<AdminRepository>().fetchOrders();
      orders.fold(
        (left) => emit(state.copyWith(
          errMsg: left.message,
          status: OrdersStatus.fetchFailure,
        )),
        (right) => emit(state.copyWith(
          ongoingOrders: right['ongoing'],
          historyOrders: right['history'],
          status: OrdersStatus.fetchSuccess,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: OrdersStatus.fetchFailure,
      ));
    }
  }

  void _onOrderSelected(AdminOrderSelectedEvent event, emit) {
    emit(state.copyWith(curOrder: event.order));
  }
}
