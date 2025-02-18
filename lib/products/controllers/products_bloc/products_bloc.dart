import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  StreamSubscription? _subscription;

  ProductsBloc() : super(ProductsState.initial) {
    on<ProductsFetchingEvent>(_onProductLoading);
    on<ProductsRelatedLoadingEvent>(_onProductRelatedLoading);
    on<ProductSelectedEvent>(_onProductSelected);
    on<ProductsUpdatedEvent>(_onProductsUpdated);
    on<ProductsStreamListeneing>(_loadProducts);

    add(ProductsStreamListeneing());
  }

  FutureOr<void> _loadProducts(event, emit) async {
    emit(state.copyWith(status: LoadStatus.inProgress));
    if (state.hasReachedMax) return;
    _subscription = sl
        .get<DataRepository>()
        .productsStream()
        .listen(
          (result) => result.fold(
            (l) => addError(l.message),
            (r) => add(ProductsUpdatedEvent(r)),
          ),
          onError: (e) => addError(e.toString()),
        );
  }

  FutureOr<void> _onProductLoading(ProductsFetchingEvent event, emit) async {
    if (state.hasReachedMax) return;
    try {
      emit(state.copyWith(status: LoadStatus.inProgress));
      final results = await sl.get<DataRepository>().fetchProducts();
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadStatus.failure,
        )),
        (r) {
          if ((r['still'] as List<Product>).isEmpty)
            return emit(state.copyWith(hasReachedMax: true));
          else
            emit(state.copyWith(
              products: [...state.products, ...r['p'] as List<Product>],
              status: LoadStatus.success,
            ));
        },
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
    if (event.products.isEmpty)
      return emit(state.copyWith(hasReachedMax: true));
    else
      emit(state.copyWith(
        products: [...state.products, ...event.products],
        status: LoadStatus.success,
        curProduct: state.curProduct,
      ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
