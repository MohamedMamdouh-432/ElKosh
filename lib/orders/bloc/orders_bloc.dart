import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersState.initial) {
    on<OrdersOnGoingFetchedEvent>(_onOngoingOrdersFetched);
    on<OrdersHistoryFetchedEvent>(_onHistoryOrdersFetched);
    on<OrderSelectedEvent>(_onOrderSelected);
    on<OrderCancellingEvent>(_onOrderCancelled);
    add(OrdersOnGoingFetchedEvent());
    add(OrdersHistoryFetchedEvent());
  }

  Future<void> _onOngoingOrdersFetched(event, emit) async {
    emit(state.copyWith(status: OrdersStatus.onProgress));
    final orders = await sl.get<DataRepository>().fetchOngoingOrders();
    orders.fold(
      (left) => emit(state.copyWith(
        errMsg: left.message,
        status: OrdersStatus.failureInOngoing,
      )),
      (right) => emit(state.copyWith(
        ongoingOrders: right,
        status: OrdersStatus.successInOngoing,
      )),
    );
  }

  Future<void> _onHistoryOrdersFetched(event, emit) async {
    emit(state.copyWith(status: OrdersStatus.onProgress));
    final orders = await sl.get<DataRepository>().fetchHistoryOrders();
    orders.fold(
      (left) => emit(state.copyWith(
        errMsg: left.message,
        status: OrdersStatus.failureInHistory,
      )),
      (right) => emit(state.copyWith(
        historyOrders: right,
        status: OrdersStatus.successInHistory,
      )),
    );
  }

  void _onOrderSelected(OrderSelectedEvent event, emit) {
    emit(state.copyWith(curOrder: event.order));
  }

  Future<void> _onOrderCancelled(OrderCancellingEvent event, emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final result = await sl.get<DataRepository>().cancelOrder(event.orderId);
      result.fold(
        (left) => emit(state.copyWith(
          errMsg: left.message,
          status: OrdersStatus.failure,
        )),
        (right) {
          state.ongoingOrders.removeWhere((order) => order.id == event.orderId);
          emit(state.copyWith(status: OrdersStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: "حدث خطأ أثناء الغاء الاوردر",
        status: OrdersStatus.failure,
      ));
    }
  }
}
