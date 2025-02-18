import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/notifications/notific2/send_notification_service.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial) {
    on<CartFetchingEvent>(_onFetchCart);
    on<CartAddingProductEvent>(_onAddProductToCart);
    on<CartRemovingProductEvent>(_onRemoveProductFromCart);
    on<CartIncreasingProductQuantityEvent>(_onIncreaseProductQuantityInCart);
    on<CartDecreasingProductQuantityEvent>(_onDecreaseProductQuantityInCart);
    on<CartPlaceOrderEvent>(_onPlacingOrder);
    on<CartPlaceAdOrderEvent>(_onPlacingAdOrder);
    on<CartResetEvent>(_onResetCart);
    on<CartAdResetEvent>(_onResetAdCart);
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
          (cnt) => cnt + 1,
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

  Future<void> _onPlacingOrder(
      CartPlaceOrderEvent event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(status: CartStatus.onProgress));
      final result = await sl.get<DataRepository>().placeOrder(event.location);
      List<String?> adminTokens =
          await sl.get<DataRepository>().getAdminTokens();
      result.fold(
        (l) => emit(state.copyWith(
          status: CartStatus.placingfailure,
          errorMessage: l.message,
        )),
        (r) async {
          Future.wait([
            Future.delayed(Duration.zero, () async {
              state.shopping.forEach((p, c) async {
                if (p.quantity - c <= 7) {
                  for (var token in adminTokens.take(2)) {
                    await SendNotificationService.sendNotificationUsingApi(
                      title: 'منتج على وشك النفاذ',
                      token: token,
                      body: 'المنتج ${p.name} تبقى منه ${p.quantity - c}',
                      data: {'type': 'orders'},
                    );
                  }
                }
              });
            }),
            Future.delayed(Duration.zero, () async {
              for (var token in adminTokens.take(2)) {
                await SendNotificationService.sendNotificationUsingApi(
                  title: 'طلب جديد',
                  token: token,
                  body: 'تم استلام طلب جديد',
                  data: {'type': 'orders'},
                );
              }
            })
          ]);
          emit(state.copyWith(status: CartStatus.placingSuccess));
        },
      );
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
      List<String?> adminTokens =
          await sl.get<DataRepository>().getAdminTokens();
      result.fold(
        (l) => emit(
          state.copyWith(
            status: CartStatus.placingfailure,
            errorMessage: l.message,
          ),
        ),
        (r) async {
          Future.wait([
            Future.delayed(Duration.zero, () async {
              state.shopping.forEach((p, c) async {
                if (p.quantity - c <= 7) {
                  for (var token in adminTokens.take(2)) {
                    await SendNotificationService.sendNotificationUsingApi(
                      title: 'منتج على وشك النفاذ',
                      token: token,
                      body: 'المنتج ${p.name} تبقى منه ${p.quantity - c}',
                      data: {'type': 'orders'},
                    );
                  }
                }
              });
            }),
            Future.delayed(Duration.zero, () async {
              for (var token in adminTokens.take(2)) {
                await SendNotificationService.sendNotificationUsingApi(
                  title: 'طلب جديد',
                  token: token,
                  body: 'تم استلام طلب جديد',
                  data: {'type': 'orders'},
                );
              }
            })
          ]);
          emit(state.copyWith(status: CartStatus.placingSuccess));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.placingfailure,
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

  Future<void> _onResetAdCart(event, emit) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final result = await sl.get<DataRepository>().resetCart();
      result.fold(
        (left) => emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage: left.message,
        )),
        (right) => emit(state.copyWith(status: CartStatus.initial)),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
