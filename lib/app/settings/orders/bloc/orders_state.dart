part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final List<UserOrder> ongoingOrders;
  final List<UserOrder> historyOrders;
  final UserOrder curOrder;
  final String errMsg;
  final OrdersStatus status;
  final bool hasOngoingsMax, hasHistorysMax;

  const OrdersState({
    required this.ongoingOrders,
    required this.historyOrders,
    required this.errMsg,
    required this.status,
    required this.curOrder,
    required this.hasOngoingsMax,
    required this.hasHistorysMax,
  });

  static OrdersState initial = OrdersState(
    ongoingOrders: const [],
    historyOrders: const [],
    errMsg: '',
    curOrder: UserOrder.empty,
    status: OrdersStatus.initial,
    hasOngoingsMax: false,
    hasHistorysMax: false,
  );

  OrdersState copyWith({
    List<UserOrder>? ongoingOrders,
    List<UserOrder>? historyOrders,
    String? errMsg,
    OrdersStatus? status,
    UserOrder? curOrder,
    bool? hasOngoingsMax,
    bool? hasHistorysMax,
  }) {
    return OrdersState(
      ongoingOrders: ongoingOrders ?? this.ongoingOrders,
      historyOrders: historyOrders ?? this.historyOrders,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
      curOrder: curOrder ?? this.curOrder,
      hasOngoingsMax: hasOngoingsMax ?? this.hasOngoingsMax,
      hasHistorysMax: hasHistorysMax ?? this.hasHistorysMax,
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
      Ongoings Reach Max: ${hasOngoingsMax ? 'YES' : 'NO'}
      History Reach Max: ${hasHistorysMax ? 'YES' : 'NO'}
    ''';
  }

  @override
  List<Object> get props => [
        ongoingOrders,
        historyOrders,
        errMsg,
        status,
        curOrder,
        hasOngoingsMax,
        hasHistorysMax,
      ];
}
