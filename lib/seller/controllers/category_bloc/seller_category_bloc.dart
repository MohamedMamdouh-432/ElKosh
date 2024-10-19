import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'seller_category_event.dart';
part 'seller_category_state.dart';

class SellerCategoryBloc extends Bloc<SellerCategoryEvent, SellerCategoryState> {
  SellerCategoryBloc() : super(SellerCategoryInitial()) {
    on<SellerCategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
