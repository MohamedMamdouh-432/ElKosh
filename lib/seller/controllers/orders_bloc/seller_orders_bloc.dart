import 'dart:async';

import 'package:admin_repository/admin_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'seller_orders_event.dart';
part 'seller_orders_state.dart';

class SellerOrdersBloc extends Bloc<SellerOrdersEvent, SellerOrdersState> {
  SellerOrdersBloc() : super(SellerOrdersState.initial) {
    on<SellerOrdersFetchedEvent>(_onOrdersFetched);
    on<SellerOrderSelectedEvent>(_onOrderSelected);
    add(SellerOrdersFetchedEvent());
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

  void _onOrderSelected(SellerOrderSelectedEvent event, emit) {
    emit(state.copyWith(curOrder: event.order));
  }
}
