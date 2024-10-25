import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc() : super(ProductFormInitial()) {
    on<ProductFormEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
