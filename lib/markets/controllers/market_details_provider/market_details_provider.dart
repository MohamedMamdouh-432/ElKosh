import 'dart:async';
import 'package:flutter/material.dart';
import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:models_repository/models_repository.dart';

class MarketDetailsProvider extends ChangeNotifier {
  Market _market = Market.empty;
  LoadStatus _status = LoadStatus.initial;
  String _errMsg = '';
  StreamSubscription? _subscription;

  MarketDetailsProvider() {
    _init();
  }

  // Getters
  Market get market => _market;
  LoadStatus get status => _status;
  String get errMsg => _errMsg;

  void _init() {
    _subscription = sl.get<DataRepository>().marketDetailsStream().listen(
      (result) {
        result.fold(
          (l) => _setError(l.message),
          (r) => _updateMarket(r),
        );
      },
      onError: (e) => _setError(e.toString()),
    );
  }

  void loadMarketDetails() {
    _status = LoadStatus.inProgress;
    notifyListeners();
    _market = sl.get<DataRepository>().getCurMarket()!;
    _status = LoadStatus.success;
    notifyListeners();
  }

  void _updateMarket(Market newMarket) {
    _market = newMarket;
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
