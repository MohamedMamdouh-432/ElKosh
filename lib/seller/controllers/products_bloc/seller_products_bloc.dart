import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'seller_products_event.dart';
part 'seller_products_state.dart';

class SellerProductsBloc extends Bloc<SellerProductsEvent, SellerProductsState> {
  SellerProductsBloc() : super(SellerProductsInitial()) {
    on<SellerProductsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
