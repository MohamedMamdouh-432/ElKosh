import 'dart:async';

import 'package:elkosh/core/services/service_locator.dart';
import 'package:elkosh/repos/data_repo.dart';
import 'package:elkosh/repos/enums/enums.dart';
import 'package:elkosh/repos/models/models.dart';
import 'package:flutter/material.dart';

class ProductDetailsProvider extends ChangeNotifier {
  Product _product = Product.empty;
  LoadStatus _status = LoadStatus.initial;
  String _errMsg = '';
  StreamSubscription? _subscription;

  ProductDetailsProvider() {
    _init();
  }

  // Getters
  Product get product => _product;
  LoadStatus get status => _status;
  String get errMsg => _errMsg;

  void _init() {
    _subscription = sl.get<DataRepo>().productDetailsStream().listen(
      (result) {
        result.fold(
          (l) => _setError(l.message),
          (r) => _updateProduct(r),
        );
      },
      onError: (e) => _setError(e.toString()),
    );
  }

  void loadProductDetails() {
    _status = LoadStatus.inProgress;
    notifyListeners();

    _product = sl.get<DataRepo>().getCurProduct()!;
    _status = LoadStatus.success;
    notifyListeners();
  }

  void _updateProduct(Product newProduct) {
    _product = newProduct;
    _status = LoadStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _errMsg = message;
    _status = LoadStatus.failure;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
