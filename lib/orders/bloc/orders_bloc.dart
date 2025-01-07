import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  StreamSubscription? _subscription;
  OrdersBloc() : super(OrdersState.initial) {
    on<OrdersFetchedEvent>(_onOrdersFetched);
    on<OrderSelectedEvent>(_onOrderSelected);
    on<OrderDeleveringingEvent>(_onOrderDelevering);
    on<OrderCancellingEvent>(_onOrderCancelled);
    on<OrdersUpdatedEvent>(_onOrdersUpdated);
    on<OrderRefusingEvent>(_onOrderRefusing);

    _subscription = sl.get<DataRepository>().ordersStream().listen(
          (result) => result.fold(
            (l) => addError(l.message),
            (r) => add(
              OrdersUpdatedEvent(
                r['ongoing'] as List<UserOrder>,
                r['history'] as List<UserOrder>,
              ),
            ),
          ),
          onError: (e) => addError(e.toString()),
        );
  }

  Future<void> _onOrdersFetched(event, emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final orders = await sl.get<DataRepository>().fetchOrders();
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

  Future<void> _onOrdersUpdated(OrdersUpdatedEvent event, emit) async {
    emit(state.copyWith(
      ongoingOrders: event.ongoingOrders,
      historyOrders: event.historyOrders,
    ));
  }

  void _onOrderSelected(OrderSelectedEvent event, emit) {
    emit(state.copyWith(curOrder: event.order));
  }

  Future<void> _onOrderDelevering(OrderDeleveringingEvent event, emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final result =
          await sl.get<DataRepository>().confirmDeliveryOrder(event.order.id);
      final newOngoingOrders = state.ongoingOrders;
      final newHistoryOrders = state.historyOrders;
      newOngoingOrders.remove(event.order);
      newHistoryOrders.add(event.order.copyWith(status: OrderStatus.delivered));
      result.fold(
        (left) => emit(state.copyWith(
          errMsg: left.message,
          status: OrdersStatus.placingFailure,
        )),
        (right) {
          emit(state.copyWith(
            ongoingOrders: newOngoingOrders,
            historyOrders: newHistoryOrders,
            status: OrdersStatus.placingSuccess,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: "حدث خطأ أثناء الغاء الاوردر",
        status: OrdersStatus.placingFailure,
      ));
    }
  }

  Future<void> _onOrderCancelled(OrderCancellingEvent event, emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final result = await sl.get<DataRepository>().cancelOrder(event.order.id);
      final newOngoingOrders = state.ongoingOrders;
      final newHistoryOrders = state.historyOrders;
      newOngoingOrders.remove(event.order);
      newHistoryOrders.add(event.order.copyWith(status: OrderStatus.cancelled));
      result.fold(
        (left) => emit(state.copyWith(
          errMsg: left.message,
          status: OrdersStatus.placingFailure,
        )),
        (right) {
          emit(state.copyWith(
            ongoingOrders: newOngoingOrders,
            historyOrders: newHistoryOrders,
            status: OrdersStatus.placingSuccess,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: "حدث خطأ أثناء الغاء الاوردر",
        status: OrdersStatus.placingFailure,
      ));
    }
  }
  
  Future<void> _onOrderRefusing(OrderRefusingEvent event, emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final result = await sl.get<DataRepository>().refuseOrder(event.order.id);
      final newOngoingOrders = state.ongoingOrders;
      final newHistoryOrders = state.historyOrders;
      newOngoingOrders.remove(event.order);
      newHistoryOrders.add(event.order.copyWith(status: OrderStatus.refused));
      result.fold(
        (left) => emit(state.copyWith(
          errMsg: left.message,
          status: OrdersStatus.placingFailure,
        )),
        (right) {
          emit(state.copyWith(
            ongoingOrders: newOngoingOrders,
            historyOrders: newHistoryOrders,
            status: OrdersStatus.placingSuccess,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: "حدث خطأ أثناء الغاء الاوردر",
        status: OrdersStatus.placingFailure,
      ));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
