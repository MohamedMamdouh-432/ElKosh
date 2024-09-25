import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsState.initial) {
    on<ProductsLoadingEvent>(_onProductLoading);
    on<ProductSelectedEvent>(_onProductSelected);
    add(const ProductsLoadingEvent());
  }

  FutureOr<void> _onProductLoading(ProductsLoadingEvent event, emit) {}

  FutureOr<void> _onProductSelected(ProductSelectedEvent event, emit) {
    sl.get<DataRepository>().setCurProduct(event.product);
    emit(state.copyWith(curProduct: event.product));
  }
}
