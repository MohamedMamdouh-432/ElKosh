part of 'orders_bloc.dart';

class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class OrdersOnGoingFetchedEvent extends OrdersEvent {}

class OrdersHistoryFetchedEvent extends OrdersEvent {}

class OrderSelectedEvent extends OrdersEvent {
  final UserOrder order;
  const OrderSelectedEvent(this.order);

  @override
  List<Object> get props => [order];
}

class OrderCancellingEvent extends OrdersEvent {
  final String orderId;
  const OrderCancellingEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}
