import 'dart:async';

import 'package:elkosh/core/services/service_locator.dart';
import 'package:elkosh/repos/data_repo.dart';
import 'package:elkosh/repos/enums/enums.dart';
import 'package:elkosh/repos/models/models.dart';
import 'package:flutter/material.dart';

class AdDetailsProvider extends ChangeNotifier {
  Ad _ad = Ad.empty;
  LoadStatus _status = LoadStatus.initial;
  String _errMsg = '';
  StreamSubscription? _subscription;

  AdDetailsProvider() {
    _init();
  }

  // Getters
  Ad get ad => _ad;
  LoadStatus get status => _status;
  String get errMsg => _errMsg;

  void _init() {
    _subscription = sl.get<DataRepo>().adDetailsStream().listen(
      (result) {
        result.fold(
          (l) => _setError(l.message),
          (r) => _updateAd(r),
        );
      },
      onError: (e) => _setError(e.toString()),
    );
  }

  void loadAdDetails() {
    _status = LoadStatus.inProgress;
    notifyListeners();

    _ad = sl.get<DataRepo>().getCurAd()!;
    _status = LoadStatus.success;
    notifyListeners();
  }

  void _updateAd(Ad newAd) {
    _ad = newAd;
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
