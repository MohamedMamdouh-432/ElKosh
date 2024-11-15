part of 'admin_notifications_bloc.dart';

class AdminNotificationsState extends Equatable {
  final List<UserOrder> ongoingOrders;
  final List<UserOrder> historyOrders;
  final UserOrder curOrder;
  final String errMsg;
  final OrdersStatus status;

  const AdminNotificationsState({
    required this.ongoingOrders,
    required this.historyOrders,
    required this.errMsg,
    required this.status,
    required this.curOrder,
  });

  static AdminNotificationsState initial = AdminNotificationsState(
    ongoingOrders: const [],
    historyOrders: const [],
    errMsg: '',
    curOrder: UserOrder.empty,
    status: OrdersStatus.initial,
  );

  AdminNotificationsState copyWith({
    List<UserOrder>? ongoingOrders,
    List<UserOrder>? historyOrders,
    String? errMsg,
    OrdersStatus? status,
    UserOrder? curOrder,
  }) {
    return AdminNotificationsState(
      ongoingOrders: ongoingOrders ?? this.ongoingOrders,
      historyOrders: historyOrders ?? this.historyOrders,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
      curOrder: curOrder ?? this.curOrder,
    );
  }

  @override
  String toString() {
    return 'OrdersState ::\nongoingOrders: ${ongoingOrders.length}\nhistoryOrders: ${historyOrders.length}\nError Message: $errMsg\nstatus: $status\ncurOrder: ${curOrder == UserOrder.empty ? Null : curOrder}\n';
  }

  @override
  List<Object> get props => [
        ongoingOrders,
        historyOrders,
        errMsg,
        status,
        curOrder,
      ];
}
