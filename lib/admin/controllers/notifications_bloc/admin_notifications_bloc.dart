import 'dart:async';

import 'package:admin_repository/admin_repository.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'admin_notifications_event.dart';
part 'admin_notifications_state.dart';

class AdminNotificationsBloc extends Bloc<AdminNotificationsEvent, AdminNotificationsState> {
  AdminNotificationsBloc() : super(AdminNotificationsState.initial) {
    on<AdminNotificationsFetchingEvent>(_onNotificationsFetched);
    on<AdminOrderSelectedEvent>(_onOrderSelected);
    add(AdminNotificationsFetchingEvent());
  }

  Future<void> _onNotificationsFetched(event, emit) async {
    try {
      emit(state.copyWith(status: OrdersStatus.onProgress));
      final orders = await sl.get<AdminRepository>().fetchNotifications();
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
