import 'package:data_repository/data_repository.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
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
          marketId: right['marketId'],
          marketName: right['marketName'],
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
          price: state.price + event.product.price,
          marketId: right['marketId'],
          marketName: right['marketName'],
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
        int count = updatedShopping[event.product]!;
        updatedShopping.remove(event.product);
        emit(state.copyWith(
          errorMessage: '',
          price: state.price - event.product.price * count,
          status: CartStatus.success,
          shopping: updatedShopping,
          marketId: right['marketId'],
          marketName: right['marketName'],
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
          price: state.price + event.product.price,
          status: CartStatus.success,
          marketId: right['marketId'],
          marketName: right['marketName'],
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
            price: state.price - (isExist ? event.product.price : 0),
            status: CartStatus.success,
            shopping: updatedShopping,
            marketId: right['marketId'],
            marketName: right['marketName'],
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
      final result = await sl.get<DataRepository>().placeOrder(
            userId: event.user.id,
            userName: event.user.name,
            location: event.location,
          );
      // todo: notify admin for that order
      // todo: decrease each product quantity
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
