part of 'admin_orders_bloc.dart';

class AdminOrdersEvent extends Equatable {
  const AdminOrdersEvent();

  @override
  List<Object> get props => [];
}

class AdminOrdersFetchedEvent extends AdminOrdersEvent {}

class AdminOrderSelectedEvent extends AdminOrdersEvent {
  final UserOrder order;
  const AdminOrderSelectedEvent(this.order);

  @override
  List<Object> get props => [order];
}
