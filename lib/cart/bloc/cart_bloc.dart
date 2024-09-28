import 'package:data_repository/data_repository.dart';
import 'package:elkosh/settings/bloc/profile_bloc.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

  Future<void> _onAddProductToCart(
    CartAddingProductEvent event,
    emit,
  ) async {
    final result =
        await sl.get<DataRepository>().addProductToCart(event.product);
    result.fold(
      (left) => emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: left.message,
      )),
      (right) {
        state.shopping.update(
          event.product,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
        emit(state.copyWith(
          errorMessage: '',
          status: CartStatus.success,
          price: state.price + event.product.price,
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
        int count = state.shopping[event.product]!;
        state.shopping.remove(event.product);
        emit(state.copyWith(
          errorMessage: '',
          price: state.price - event.product.price * count,
          status: CartStatus.success,
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
        state.shopping.update(
          event.product,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
        emit(state.copyWith(
          errorMessage: '',
          price: state.price + event.product.price,
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
          bool isExist = state.shopping.containsKey(event.product);
          state.shopping.update(
            event.product,
            (value) => value - 1,
            ifAbsent: null,
          );
          if (state.shopping[event.product] == 0)
            state.shopping.remove(event.product);
          emit(state.copyWith(
            errorMessage: '',
            price: state.price - (isExist ? event.product.price : 0),
            status: CartStatus.success,
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
      final userProfileState =
          BlocProvider.of<ProfileBloc>(event.context).state;
      final result = await sl.get<DataRepository>().placeOrder(
            userProfileState.user.name,
            userProfileState.user.imgUrl,
          );
      result.fold(
          (left) => emit(state.copyWith(
                status: CartStatus.placingfailure,
                errorMessage: left.message,
              )),
          (right) => emit(state.copyWith(status: CartStatus.placingSuccess)));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.placingfailure,
        errorMessage: e.toString(),
      ));
    }
  }
}
