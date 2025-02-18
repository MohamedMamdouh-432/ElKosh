part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductsFetchingEvent extends ProductsEvent {
  final int? limit;
  const ProductsFetchingEvent([this.limit]);

  @override
  List<Object> get props => [limit ?? 0];
}

class ProductsRelatedLoadingEvent extends ProductsEvent {}

class ProductSelectedEvent extends ProductsEvent {
  final Product product;
  const ProductSelectedEvent(this.product);

  @override
  List<Object> get props => [product];
}

class ProductsUpdatedEvent extends ProductsEvent {
  final List<Product> products;
  const ProductsUpdatedEvent(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsStreamListeneing extends ProductsEvent {}
