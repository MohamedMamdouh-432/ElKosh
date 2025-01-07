part of 'orders_bloc.dart';

class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class OrdersFetchedEvent extends OrdersEvent {}

class OrderSelectedEvent extends OrdersEvent {
  final UserOrder order;
  const OrderSelectedEvent(this.order);

  @override
  List<Object> get props => [order];
}

class CurOrderLoadingEvent extends OrdersEvent {}

class OrderDeleveringingEvent extends OrdersEvent {
  final UserOrder order;
  const OrderDeleveringingEvent(this.order);

  @override
  List<Object> get props => [order];
}

class OrderCancellingEvent extends OrdersEvent {
  final UserOrder order;
  const OrderCancellingEvent(this.order);

  @override
  List<Object> get props => [order];
}

class OrdersUpdatedEvent extends OrdersEvent {
  final List<UserOrder> ongoingOrders;
  final List<UserOrder> historyOrders;
  
  const OrdersUpdatedEvent(this.ongoingOrders, this.historyOrders);
  
  @override
  List<Object> get props => [ongoingOrders, historyOrders];
}

class OrderRefusingEvent extends OrdersEvent {
  final UserOrder order;
  const OrderRefusingEvent(this.order);

  @override
  List<Object> get props => [order];
}
