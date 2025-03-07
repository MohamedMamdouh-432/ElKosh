import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/app/notifications/notific2/send_notification_service.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial);

  Future<void> fetchCart() async {
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

  Future<void> addProductToCart(Product p) async {
    final result = await sl.get<DataRepository>().addProductToCart(p);
    result.fold(
      (left) => emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: left.message,
      )),
      (right) {
        final updatedShopping = Map<Product, int>.of(state.shopping);
        updatedShopping.update(
          p,
          (cnt) => cnt + 1,
          ifAbsent: () => 1,
        );
        emit(state.copyWith(
          shopping: updatedShopping,
          errorMessage: '',
          status: CartStatus.success,
          price: state.price + p.updatedPrice,
        ));
      },
    );
  }

  Future<void> removeProductFromCart(Product p) async {
    final result = await sl.get<DataRepository>().removeProductFromCart(p);
    result.fold(
      (left) => emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: left.message,
      )),
      (right) {
        final updatedShopping = Map<Product, int>.of(state.shopping);
        int count = updatedShopping[p] ?? 0;
        updatedShopping.remove(p);
        emit(state.copyWith(
          errorMessage: '',
          price: state.price - (p.updatedPrice * count),
          status: CartStatus.success,
          shopping: updatedShopping,
        ));
      },
    );
  }

  Future<void> increaseProductCartQuantity(Product p) async {
    final result =
        await sl.get<DataRepository>().increaseProductQuantityInCart(p);
    result.fold(
      (left) => emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: left.message,
      )),
      (right) {
        final updatedShopping = Map<Product, int>.of(state.shopping);
        updatedShopping.update(
          p,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
        emit(state.copyWith(
          shopping: updatedShopping,
          errorMessage: '',
          price: state.price + p.updatedPrice,
          status: CartStatus.success,
        ));
      },
    );
  }

  Future<void> decreaseProductCartQuantity(Product p) async {
    try {
      final result =
          await sl.get<DataRepository>().decreaseProductQuantityFromCart(p);
      result.fold(
        (left) => emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage: left.message,
        )),
        (right) {
          Map<Product, int> updatedShopping =
              Map<Product, int>.of(state.shopping);
          bool isExist = updatedShopping.containsKey(p);
          updatedShopping.update(
            p,
            (value) => value - 1,
            ifAbsent: null,
          );
          if (updatedShopping[p] == 0) updatedShopping.remove(p);
          emit(state.copyWith(
            errorMessage: '',
            price: state.price - (isExist ? p.updatedPrice : 0),
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

  Future<void> placeOrder(Location location) async {
    try {
      emit(state.copyWith(status: CartStatus.onProgress));
      final result = await sl.get<DataRepository>().placeOrder(location);
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

  Future<void> placeAdOrder(Location location) async {
    try {
      emit(state.copyWith(status: CartStatus.onProgress));
      final result =
          await sl.get<DataRepository>().placeAdOrder(location);
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

  Future<void> resetCart() async {
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

  Future<void> resetAdCart() async {
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
