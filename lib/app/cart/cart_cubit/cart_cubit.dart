import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/app/notifications/notific2/send_notification_service.dart';
import 'package:elkosh/core/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial);

  Future<void> fetchCart() async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final result = await sl.get<DataRepo>().fetchCart();
      result.fold(
        (left) => emit(state.copyWith(
          status: CartStatus.failure,
          errMsg: left.message,
        )),
        (right) => emit(state.copyWith(
          errMsg: '',
          price: right['price'],
          items: right['shopping'],
          ads: right['ads'],
          status: CartStatus.success,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errMsg: e.toString(),
      ));
    }
  }

  Future<void> addProductToCart(Product p) async {
    final result = await sl.get<DataRepo>().addProductToCart(p);
    result.fold(
      (left) => emit(state.copyWith(
        status: CartStatus.failure,
        errMsg: left.message,
      )),
      (right) {
        final updatedItems = Map<Product, int>.of(state.items);
        updatedItems.update(
          p,
          (cnt) => cnt + 1,
          ifAbsent: () => 1,
        );
        emit(state.copyWith(
          items: updatedItems,
          errMsg: '',
          status: CartStatus.success,
          price: state.price + p.updatedPrice,
        ));
      },
    );
  }

  Future<void> removeProductFromCart(Product p, [bool isAll = false]) async {
    try {
      final result = await sl.get<DataRepo>().removeProductFromCart(p, isAll);
      result.fold(
        (left) => emit(state.copyWith(
          errMsg: left.message,
          status: CartStatus.failure,
        )),
        (right) {
          if (isAll) {
            final updatedItems = Map<Product, int>.of(state.items);
            int count = updatedItems[p] ?? 0;
            updatedItems.remove(p);
            emit(state.copyWith(
              errMsg: '',
              price: state.price - (p.updatedPrice * count),
              status: CartStatus.success,
              items: updatedItems,
            ));
          } else {
            final updatedItems = Map<Product, int>.of(state.items);
            bool isExist = updatedItems.containsKey(p);
            updatedItems.update(
              p,
              (value) => value - 1,
            );
            if (updatedItems[p] == 0) updatedItems.remove(p);
            emit(state.copyWith(
              errMsg: '',
              price: state.price - (isExist ? p.updatedPrice : 0),
              status: CartStatus.success,
              items: updatedItems,
            ));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errMsg: e.toString(),
      ));
    }
  }

  Future<void> addAdToCart(Ad ad) async {
    final result = await sl.get<DataRepo>().addAdToCart(ad);
    result.fold(
      (left) => emit(state.copyWith(
        status: CartStatus.failure,
        errMsg: left.message,
      )),
      (right) {
        final updatedAds = Map<Ad, int>.of(state.ads);
        updatedAds.update(
          ad,
          (cnt) => cnt + 1,
          ifAbsent: () => 1,
        );
        emit(state.copyWith(
          ads: updatedAds,
          errMsg: '',
          status: CartStatus.success,
          price: state.price + ad.total,
        ));
      },
    );
  }

  Future<void> removeAdFromCart(Ad ad, [bool isAll = false]) async {
    try {
      final result = await sl.get<DataRepo>().removeAdFromCart(ad, isAll);
      result.fold(
        (left) => emit(state.copyWith(
          errMsg: left.message,
          status: CartStatus.failure,
        )),
        (right) {
          if (isAll) {
            final updatedAds = Map<Ad, int>.of(state.ads);
            int count = updatedAds[ad] ?? 0;
            updatedAds.remove(ad);
            emit(state.copyWith(
              errMsg: '',
              price: state.price - (ad.total * count),
              status: CartStatus.success,
              ads: updatedAds,
            ));
          } else {
            final updatedAds = Map<Ad, int>.of(state.ads);
            bool isExist = updatedAds.containsKey(ad);
            updatedAds.update(
              ad,
              (value) => value - 1,
            );
            if (updatedAds[ad] == 0) updatedAds.remove(ad);
            emit(state.copyWith(
              errMsg: '',
              price: state.price - (isExist ? ad.total : 0),
              status: CartStatus.success,
              ads: updatedAds,
            ));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errMsg: e.toString(),
      ));
    }
  }

  Future<void> placeOrder(Location location) async {
    try {
      emit(state.copyWith(status: CartStatus.onProgress));
      final result = await sl.get<DataRepo>().placeOrder(location);
      List<String?> adminTokens = await sl.get<DataRepo>().getAdminTokens();
      result.fold(
        (l) => emit(state.copyWith(
          status: CartStatus.placingfailure,
          errMsg: l.message,
        )),
        (r) async {
          Future.wait([
            Future.delayed(Duration.zero, () async {
              state.items.forEach((p, c) async {
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
              state.ads.forEach((ad, c) async {
                for (Offer offer in ad.offers) {
                  if (offer.quantity - c <= 7) {
                    for (var token in adminTokens.take(2)) {
                      await SendNotificationService.sendNotificationUsingApi(
                        title: 'عرض على وشك النفاذ',
                        token: token,
                        body:
                            'العرض ${offer.product.name} تبقى منه ${offer.quantity - c}',
                        data: {'type': 'offers'},
                      );
                    }
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
        errMsg: e.toString(),
      ));
    }
  }

  Future<void> resetCart() async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final result = await sl.get<DataRepo>().resetCart();
      result.fold(
        (left) => emit(state.copyWith(
          status: CartStatus.failure,
          errMsg: left.message,
        )),
        (right) => emit(CartState.initial),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errMsg: e.toString(),
      ));
    }
  }
}
