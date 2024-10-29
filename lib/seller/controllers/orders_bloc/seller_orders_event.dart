part of 'seller_orders_bloc.dart';

class SellerOrdersEvent extends Equatable {
  const SellerOrdersEvent();

  @override
  List<Object> get props => [];
}

class SellerOrdersFetchedEvent extends SellerOrdersEvent {}

class SellerOrderSelectedEvent extends SellerOrdersEvent {
  final UserOrder order;
  const SellerOrderSelectedEvent(this.order);

  @override
  List<Object> get props => [order];
}
