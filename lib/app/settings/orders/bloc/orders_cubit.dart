import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/core/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  StreamSubscription? _subscription;
  OrdersCubit() : super(OrdersState.initial);

  Future<void> fetchOngoingOrders() async {
    if (state.hasOngoingsMax) return;
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final orders = await sl
          .get<DataRepo>()
          .fetchOngoingOrders(state.ongoingOrders.length);
      orders.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: OrdersStatus.fetchFailure,
        )),
        (r) {
          final skip = r['skip'];
          final data = r['data'] as List<UserOrder>;
          if (data.isEmpty && !skip) {
            emit(state.copyWith(
              hasOngoingsMax: true,
              status: OrdersStatus.fetchSuccess,
            ));
          } else {
            emit(state.copyWith(
              ongoingOrders: [...state.ongoingOrders, ...data],
              status: OrdersStatus.fetchSuccess,
            ));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: OrdersStatus.fetchFailure,
      ));
    }
  }

  Future<void> fetchHistoryOrders() async {
    if (state.hasHistorysMax) return;
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final orders = await sl
          .get<DataRepo>()
          .fetchHistoryOrders(state.historyOrders.length);
      orders.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: OrdersStatus.fetchFailure,
        )),
        (r) {
          final skip = r['skip'];
          final data = r['data'] as List<UserOrder>;
          if (data.isEmpty && !skip) {
            emit(state.copyWith(
              hasHistorysMax: true,
              status: OrdersStatus.fetchSuccess,
            ));
          } else {
            emit(state.copyWith(
              historyOrders: [...state.historyOrders, ...data],
              status: OrdersStatus.fetchSuccess,
            ));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: OrdersStatus.fetchFailure,
      ));
    }
  }

  void selectOrder(UserOrder order) => emit(state.copyWith(curOrder: order));

  Future<void> deliverOrder(UserOrder order) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final result = await sl.get<DataRepo>().confirmDeliveryOrder(order.id);
      final newOngoingOrders = state.ongoingOrders;
      final newHistoryOrders = state.historyOrders;
      newOngoingOrders.remove(order);
      newHistoryOrders.add(order.copyWith(status: OrderStatus.delivered));
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
        errMsg: "حدث خطأ أثناء تأكيد الاوردر",
        status: OrdersStatus.placingFailure,
      ));
    }
  }

  Future<void> cancelOrder(UserOrder order) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final result = await sl.get<DataRepo>().cancelOrder(order.id);
      final newOngoingOrders = state.ongoingOrders;
      final newHistoryOrders = state.historyOrders;
      newOngoingOrders.remove(order);
      newHistoryOrders.add(order.copyWith(status: OrderStatus.cancelled));
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

  Future<void> refuseOrder(UserOrder order) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final result = await sl.get<DataRepo>().refuseOrder(order.id);
      final newOngoingOrders = state.ongoingOrders;
      final newHistoryOrders = state.historyOrders;
      newOngoingOrders.remove(order);
      newHistoryOrders.add(order.copyWith(status: OrderStatus.refused));
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
        errMsg: "حدث خطأ أثناء رفض الاوردر",
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
