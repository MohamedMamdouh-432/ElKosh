import 'dart:async';

import 'package:admin_repository/admin_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'admin_products_event.dart';
part 'admin_products_state.dart';

class AdminProductsBloc extends Bloc<AdminProductsEvent, AdminProductsState> {
  AdminProductsBloc() : super(AdminProductsState.initial) {
    on<AdminProductsLoadingEvent>(_onProductsLoading);
    on<AdminProductSelectedEvent>(_onProductSelected);
    on<AdminProductDeletingEvent>(_onProductDeleting);
  }

  FutureOr<void> _onProductsLoading(
      AdminProductsLoadingEvent event, emit) async {
    try {
      emit(state.copyWith(status: LoadingStatus.inProgress));
      final results = await sl.get<AdminRepository>().fetchProducts();
      results.fold(
        (l) => emit(state.copyWith(
          errMsg: l.message,
          status: LoadingStatus.failure,
        )),
        (r) => emit(state.copyWith(
          products: r,
          status: LoadingStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadingStatus.failure,
      ));
    }
  }

  FutureOr<void> _onProductSelected(AdminProductSelectedEvent event, emit) {
    try {
      emit(state.copyWith(
        curProduct: event.product,
        status: LoadingStatus.inProgress,
      ));
      sl.get<AdminRepository>().setCurProduct(event.product);
      emit(state.copyWith(
        status: LoadingStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        errMsg: e.toString(),
        status: LoadingStatus.failure,
      ));
    }
  }

  FutureOr<void> _onProductDeleting(
      AdminProductDeletingEvent event, emit) async {
    try {
      await sl.get<AdminRepository>().deleteProduct(event.productId);
      final updatedProducts = List<Product>.from(state.products)
        ..removeWhere((m) => m.id == event.productId);
      emit(state.copyWith(products: updatedProducts));
    } catch (e) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        errMsg: e.toString(),
      ));
    }
  }
}
