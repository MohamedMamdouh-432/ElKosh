import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  StreamSubscription? _subscription;
  ProductDetailsBloc() : super(ProductDetailsState.initial) {
    on<ProductDetailsLoadingEvent>(_onProductDetailsLoaded);
    on<ProductDetailsUpdatingEvent>(_onProductDetailsUpdated);

    _subscription = sl.get<DataRepository>().productDetailsStream().listen(
          (result) => result.fold((l) => addError(l.message),
              (r) => add(ProductDetailsUpdatingEvent(r))),
        );
  }
  
  FutureOr<void> _onProductDetailsLoaded(
      ProductDetailsLoadingEvent event, emit) {
    emit(state.copyWith(status: LoadingStatus.inProgress));
    emit(state.copyWith(
      status: LoadingStatus.success,
      product: sl.get<DataRepository>().getCurProduct(),
    ));
  }

  FutureOr<void> _onProductDetailsUpdated(
      ProductDetailsUpdatingEvent event, emit) {
    emit(state.copyWith(
      product: event.product,
      status: LoadingStatus.success,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
