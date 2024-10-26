part of 'product_form_bloc.dart';

sealed class ProductFormEvent extends Equatable {
  const ProductFormEvent();

  @override
  List<Object> get props => [];
}

class ProductFormPrepared extends ProductFormEvent {
  final Product product;
  const ProductFormPrepared(this.product);

  @override
  List<Object> get props => [product];
}

class ProductFormNameChanged extends ProductFormEvent {
  final String name;
  const ProductFormNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class ProductFormDescChanged extends ProductFormEvent {
  final String desc;
  const ProductFormDescChanged(this.desc);

  @override
  List<Object> get props => [desc];
}

class ProductFormPriceChanged extends ProductFormEvent {
  final double price;
  const ProductFormPriceChanged(this.price);

  @override
  List<Object> get props => [price];
}

class ProductFormQuantityChanged extends ProductFormEvent {
  final double quantity;
  const ProductFormQuantityChanged(this.quantity);

  @override
  List<Object> get props => [quantity];
}

class ProductFormUnitChanged extends ProductFormEvent {
  final String unit;
  const ProductFormUnitChanged(this.unit);

  @override
  List<Object> get props => [unit];
}

class ProductFormUnitValChanged extends ProductFormEvent {
  final double unitVal;
  const ProductFormUnitValChanged(this.unitVal);

  @override
  List<Object> get props => [unitVal];
}

class ProductFormImgChanged extends ProductFormEvent {}

class ProductAddFormSubmitted extends ProductFormEvent {}

class ProductEditFormSubmitted extends ProductFormEvent {}

class ProductFormResetRequested extends ProductFormEvent {}

class ProductFormStatusResetRequested extends ProductFormEvent {}
