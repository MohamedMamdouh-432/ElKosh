part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final List<UserOrder> ongoingOrders;
  final List<UserOrder> historyOrders;
  final UserOrder curOrder;
  final String errMsg;
  final OrdersStatus status;
  final bool hasReachedMax;

  const OrdersState({
    required this.ongoingOrders,
    required this.historyOrders,
    required this.errMsg,
    required this.status,
    required this.curOrder,
    required this.hasReachedMax,
  });

  static OrdersState initial = OrdersState(
    ongoingOrders: const [],
    historyOrders: const [],
    errMsg: '',
    curOrder: UserOrder.empty,
    status: OrdersStatus.initial,
    hasReachedMax: false,
  );

  OrdersState copyWith({
    List<UserOrder>? ongoingOrders,
    List<UserOrder>? historyOrders,
    String? errMsg,
    OrdersStatus? status,
    UserOrder? curOrder,
    bool? hasReachedMax,
  }) {
    return OrdersState(
      ongoingOrders: ongoingOrders ?? this.ongoingOrders,
      historyOrders: historyOrders ?? this.historyOrders,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
      curOrder: curOrder ?? this.curOrder,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
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
      Reach Max: ${hasReachedMax ? 'YES' : 'NO'}
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
