part of 'orders_bloc.dart';

class OrdersState extends Equatable {
  final List<UserOrder> ongoingOrders;
  final List<UserOrder> historyOrders;
  final UserOrder curOrder;
  final String errMsg;
  final OrdersStatus status;

  const OrdersState({
    required this.ongoingOrders,
    required this.historyOrders,
    required this.errMsg,
    required this.status,
    required this.curOrder,
  });

  static OrdersState initial = OrdersState(
    ongoingOrders: const [],
    historyOrders: const [],
    errMsg: '',
    curOrder: UserOrder.empty,
    status: OrdersStatus.initial,
  );

  OrdersState copyWith({
    List<UserOrder>? ongoingOrders,
    List<UserOrder>? historyOrders,
    String? errMsg,
    OrdersStatus? status,
    UserOrder? curOrder,
  }) {
    return OrdersState(
      ongoingOrders: ongoingOrders ?? this.ongoingOrders,
      historyOrders: historyOrders ?? this.historyOrders,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
      curOrder: curOrder ?? this.curOrder,
    );
  }

  @override
  String toString() {
    return '''OrdersState ::
      ongoingOrders: ${ongoingOrders.length}
      historyOrders: ${historyOrders.length}
      Error: $errMsg
      status: ${status.name}
      curOrder Id: ${curOrder == UserOrder.empty ? Null : curOrder.id}
    ''';
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
