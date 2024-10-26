part of 'seller_products_bloc.dart';

sealed class SellerProductsEvent extends Equatable {
  const SellerProductsEvent();

  @override
  List<Object> get props => [];
}

class SellerProductsLoadingEvent extends SellerProductsEvent {}

class SellerProductSelectedEvent extends SellerProductsEvent {
  final Product product;
  const SellerProductSelectedEvent(this.product);

  @override
  List<Object> get props => [Product];
}

class SellerProductAddingEvent extends SellerProductsEvent {}

class SellerProductDeletingEvent extends SellerProductsEvent {
  final String productId;
  const SellerProductDeletingEvent(this.productId);

  @override
  List<Object> get props => [productId];
}
