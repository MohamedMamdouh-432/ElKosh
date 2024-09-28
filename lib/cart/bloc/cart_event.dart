part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartFetchingEvent extends CartEvent {}

class CartRequestEvent extends CartEvent {}

class CartResetEvent extends CartEvent {}

class CartAddingProductEvent extends CartEvent {
  final Product product;
  const CartAddingProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class CartRemovingProductEvent extends CartEvent {
  final Product product;
  const CartRemovingProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class CartIncreasingProductQuantityEvent extends CartEvent {
  final Product product;
  const CartIncreasingProductQuantityEvent(this.product);

  @override
  List<Object> get props => [product];
}

class CartDecreasingProductQuantityEvent extends CartEvent {
  final Product product;
  const CartDecreasingProductQuantityEvent(this.product);

  @override
  List<Object> get props => [product];
}

class CartPlaceOrderEvent extends CartEvent {
  final BuildContext context;

  const CartPlaceOrderEvent(this.context);
  
  @override
  List<Object> get props => [context];
}
