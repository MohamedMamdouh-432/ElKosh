// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'seller_category_bloc.dart';

sealed class SellerCategoryEvent extends Equatable {
  const SellerCategoryEvent();

  @override
  List<Object> get props => [];
}

class SellerCategorysLoadingEvent extends SellerCategoryEvent {}

class SellerCategorySelectedEvent extends SellerCategoryEvent {
  final Category category;
  const SellerCategorySelectedEvent(this.category);

  @override
  List<Object> get props => [category];
}

class SellerCategoryAddingEvent extends SellerCategoryEvent {
  final MapEntry categoryItem;
  const SellerCategoryAddingEvent(this.categoryItem);
  
  @override
  List<Object> get props => [categoryItem];
}

class SellerCategoryDeletingEvent extends SellerCategoryEvent {
  final String categoryId;
  const SellerCategoryDeletingEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SellerCategoryResetEvent extends SellerCategoryEvent {}