part of 'product_details_bloc.dart';

sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class ProductDetailsLoadingEvent extends ProductDetailsEvent {}

class ProductDetailsUpdatingEvent extends ProductDetailsEvent {
  final Product product;

  const ProductDetailsUpdatingEvent(this.product);

  @override
  List<Object> get props => [product];
}
