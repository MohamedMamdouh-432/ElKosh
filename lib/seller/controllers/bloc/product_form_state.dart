part of 'product_form_bloc.dart';

sealed class ProductFormState extends Equatable {
  const ProductFormState();
  
  @override
  List<Object> get props => [];
}

final class ProductFormInitial extends ProductFormState {}
