part of 'admin_products_bloc.dart';

sealed class AdminProductsEvent extends Equatable {
  const AdminProductsEvent();

  @override
  List<Object> get props => [];
}

class AdminProductsLoadingEvent extends AdminProductsEvent {}

class AdminProductSelectedEvent extends AdminProductsEvent {
  final Product product;
  const AdminProductSelectedEvent(this.product);

  @override
  List<Object> get props => [Product];
}

class AdminProductAddingEvent extends AdminProductsEvent {}

class AdminProductDeletingEvent extends AdminProductsEvent {
  final String productId;
  const AdminProductDeletingEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class AdminProductUpdatingEvent extends AdminProductsEvent {
  final double price;
  const AdminProductUpdatingEvent(this.price);

  @override
  List<Object> get props => [price];
}
