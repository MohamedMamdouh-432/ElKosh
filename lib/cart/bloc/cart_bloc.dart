import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial) {
    on<CartFetchingEvent>(_onFetchCart);
    on<CartResetEvent>(_onResetCart);
    on<CartAddingProductEvent>(_onAddProductToCart);
    on<CartRemovingProductEvent>(_onRemoveProductFromCart);
    on<CartIncreasingProductQuantityEvent>(_onIncreaseProductQuantityInCart);
    on<CartDecreasingProductQuantityEvent>(_onDecreaseProductQuantityInCart);
    on<CartPlaceOrderEvent>(_onPlacingOrder);
    on<CartPlaceAdOrderEvent>(_onPlacingAdOrder);
  }

  Future<void> _onFetchCart(event, emit) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final result = await sl.get<DataRepository>().fetchCart();
      result.fold(
        (left) => emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage: left.message,
        )),
        (right) => emit(state.copyWith(
          errorMessage: '',
          price: right['price'],
          shopping: right['shopping'],
          status: CartStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onResetCart(event, emit) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final result = await sl.get<DataRepository>().resetCart();
      result.fold(
        (left) => emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage: left.message,
        )),
        (right) => emit(CartState.initial),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddProductToCart(CartAddingProductEvent event, emit) async {
    final result =
        await sl.get<DataRepository>().addProductToCart(event.product);
    result.fold(
      (left) => emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: left.message,
      )),
      (right) {
        final updatedShopping = Map<Product, int>.of(state.shopping);
        updatedShopping.update(
          event.product,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
        emit(state.copyWith(
          shopping: updatedShopping,
          errorMessage: '',
          status: CartStatus.success,
          price: state.price + event.product.updatedPrice,
        ));
      },
    );
  }

  Future<void> _onRemoveProductFromCart(
      CartRemovingProductEvent event, emit) async {
    final result =
        await sl.get<DataRepository>().removeProductFromCart(event.product);
    result.fold(
      (left) => emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: left.message,
      )),
      (right) {
        final updatedShopping = Map<Product, int>.of(state.shopping);
        int count = updatedShopping[event.product] ?? 0;
        updatedShopping.remove(event.product);
        emit(state.copyWith(
          errorMessage: '',
          price: state.price - (event.product.updatedPrice * count),
          status: CartStatus.success,
          shopping: updatedShopping,
        ));
      },
    );
  }

  Future<void> _onIncreaseProductQuantityInCart(
      CartIncreasingProductQuantityEvent event, emit) async {
    final result = await sl
        .get<DataRepository>()
        .increaseProductQuantityInCart(event.product);
    result.fold(
      (left) => emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: left.message,
      )),
      (right) {
        final updatedShopping = Map<Product, int>.of(state.shopping);
        updatedShopping.update(
          event.product,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
        emit(state.copyWith(
          shopping: updatedShopping,
          errorMessage: '',
          price: state.price + event.product.updatedPrice,
          status: CartStatus.success,
        ));
      },
    );
  }

  Future<void> _onDecreaseProductQuantityInCart(
      CartDecreasingProductQuantityEvent event, emit) async {
    try {
      final result = await sl
          .get<DataRepository>()
          .decreaseProductQuantityFromCart(event.product);
      result.fold(
        (left) => emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage: left.message,
        )),
        (right) {
          Map<Product, int> updatedShopping =
              Map<Product, int>.of(state.shopping);
          bool isExist = updatedShopping.containsKey(event.product);
          updatedShopping.update(
            event.product,
            (value) => value - 1,
            ifAbsent: null,
          );
          if (updatedShopping[event.product] == 0)
            updatedShopping.remove(event.product);
          emit(state.copyWith(
            errorMessage: '',
            price: state.price - (isExist ? event.product.updatedPrice : 0),
            status: CartStatus.success,
            shopping: updatedShopping,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPlacingOrder(CartPlaceOrderEvent event, emit) async {
    try {
      emit(state.copyWith(status: CartStatus.onProgress));
      final result = await sl.get<DataRepository>().placeOrder(event.location);
      // todo: send notification to admin (later when notifications feature is ready)
      result.fold(
          (l) => emit(state.copyWith(
                status: CartStatus.placingfailure,
                errorMessage: l.message,
              )),
          (r) => emit(state.copyWith(status: CartStatus.placingSuccess)));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.placingfailure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPlacingAdOrder(CartPlaceAdOrderEvent event, emit) async {
    try {
      emit(state.copyWith(status: CartStatus.onProgress));
      final result =
          await sl.get<DataRepository>().placeAdOrder(event.location);
      // todo: send notification to admin (later when notifications feature is ready)
      result.fold(
          (l) => emit(state.copyWith(
                status: CartStatus.placingfailure,
                errorMessage: l.message,
              )),
          (r) => emit(state.copyWith(status: CartStatus.placingSuccess)));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.placingfailure,
        errorMessage: e.toString(),
      ));
    }
  }
}
