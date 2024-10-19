part of 'seller_category_bloc.dart';

sealed class SellerCategoryState extends Equatable {
  const SellerCategoryState();
  
  @override
  List<Object> get props => [];
}

final class SellerCategoryInitial extends SellerCategoryState {}
