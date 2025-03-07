import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  StreamSubscription? _subscription;
  DocumentSnapshot? lastDocument;
  final DataRepository _dataRepository = sl.get<DataRepository>();

  ProductsCubit() : super(ProductsState.initial) {
    fetchProducts();
  }

  Future<void> fetchMoreProducts() async {
    emit(state.copyWith(status: LoadStatus.inProgress));
    if (state.hasReachedMax) return;
    _subscription?.cancel();
    _subscription =
        _dataRepository.productsStream(state.products.length).listen(
              (result) => result.fold(
                (l) => emit(
                  state.copyWith(
                    errMsg: l.message,
                    status: LoadStatus.failure,
                  ),
                ),
                (r) {
                  final skip = r['skip'];
                  final data = r['data'] as List<Product>;
                  if (data.isEmpty && !skip) {
                    emit(state.copyWith(hasReachedMax: true));
                  } else {
                    emit(state.copyWith(
                      products: [...state.products, ...data],
                      status: LoadStatus.success,
                    ));
                  }
                },
              ),
              onError: (e) => emit(
                state.copyWith(
                  errMsg: e.toString(),
                  status: LoadStatus.failure,
                ),
              ),
            );
  }

  Future<void> fetchProducts() async {
    if (state.hasReachedMax) return;

    try {
      emit(state.copyWith(status: LoadStatus.inProgress));
      final results =
          await _dataRepository.fetchProducts(state.products.length);
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadStatus.failure,
        )),
        (r) {
          final skip = r['skip'];
          final data = r['data'] as List<Product>;
          if (data.isEmpty && !skip) {
            emit(state.copyWith(hasReachedMax: true));
          } else {
            emit(state.copyWith(
              products: [...state.products, ...data],
              status: LoadStatus.success,
            ));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(errMsg: e.toString(), status: LoadStatus.failure));
    }
  }

  Future<void> fetchRelatedProducts() async {
    try {
      emit(state.copyWith(status: LoadStatus.inProgress));
      final results = await _dataRepository.fetchCategoryRelatedProducts();
      results.fold(
        (failure) => emit(state.copyWith(
            errMsg: failure.message, status: LoadStatus.failure)),
        (products) => emit(
            state.copyWith(relProducts: products, status: LoadStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(errMsg: e.toString(), status: LoadStatus.failure));
    }
  }

  void selectProduct(Product product) {
    _dataRepository.setCurProduct(product);
    emit(state.copyWith(curProduct: product));
  }

  void updateProducts(List<Product> products) {
    if (products.isEmpty) {
      emit(state.copyWith(hasReachedMax: true));
    } else {
      emit(state.copyWith(
          products: [...state.products, ...products],
          status: LoadStatus.success));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
