part of 'seller_products_bloc.dart';

sealed class SellerProductsState extends Equatable {
  const SellerProductsState();
  
  @override
  List<Object> get props => [];
}

final class SellerProductsInitial extends SellerProductsState {}
