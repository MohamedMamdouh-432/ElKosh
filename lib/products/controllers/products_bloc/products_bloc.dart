import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  StreamSubscription? _tinySubscription, _bigSubscription;

  ProductsBloc() : super(ProductsState.initial) {
    on<ProductsLoadingEvent>(_onProductLoading);
    on<ProductsRelatedLoadingEvent>(_onProductRelatedLoading);
    on<ProductSelectedEvent>(_onProductSelected);
    on<ProductsUpdatedEvent>(_onProductsUpdated);

    _tinySubscription = sl.get<DataRepository>().productsStream(10).listen(
          (result) => result.fold(
            (l) => addError(l.message),
            (r) => add(ProductsUpdatedEvent(r)),
          ),
          onError: (e) => addError(e.toString()),
        );
        
    _bigSubscription = sl.get<DataRepository>().productsStream(null).listen(
          (result) => result.fold(
            (l) => addError(l.message),
            (r) => add(ProductsUpdatedEvent(r)),
          ),
          onError: (e) => addError(e.toString()),
        );
  }

  FutureOr<void> _onProductLoading(ProductsLoadingEvent event, emit) async {
    try {
      emit(state.copyWith(status: LoadStatus.inProgress));
      final results = await sl.get<DataRepository>().fetchProducts(event.limit);
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadStatus.failure,
        )),
        (r) => emit(state.copyWith(
          products: r,
          status: LoadStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadStatus.failure,
      ));
    }
  }

  FutureOr<void> _onProductRelatedLoading(event, emit) async {
    try {
      emit(state.copyWith(status: LoadStatus.inProgress));
      final results =
          await sl.get<DataRepository>().fetchCategoryRelatedProducts();
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadStatus.failure,
        )),
        (r) => emit(state.copyWith(
          relProducts: r,
          status: LoadStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadStatus.failure,
      ));
    }
  }

  FutureOr<void> _onProductSelected(ProductSelectedEvent event, emit) {
    sl.get<DataRepository>().setCurProduct(event.product);
    emit(state.copyWith(curProduct: event.product));
  }

  FutureOr<void> _onProductsUpdated(ProductsUpdatedEvent event, emit) {
    emit(state.copyWith(status: LoadStatus.updated));
    emit(state.copyWith(
      products: event.products,
      status: LoadStatus.success,
      curProduct: state.curProduct,
    ));
  }

  @override
  Future<void> close() {
    _tinySubscription?.cancel();
    _bigSubscription?.cancel();
    _tinySubscription = null;
    _bigSubscription = null;
    return super.close();
  }
}
