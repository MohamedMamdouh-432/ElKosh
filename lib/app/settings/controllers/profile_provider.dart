import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:elkosh/core/services/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:models_repository/models_repository.dart';
import 'package:user_repository/user_repository.dart';

class ProfileProvider extends ChangeNotifier {
  User _user = User.empty;
  ProfileStatus _status = ProfileStatus.initial;
  String? _errMsg;

  User get user => _user;
  ProfileStatus get status => _status;
  String? get errMsg => _errMsg;

  Future<void> loadProfile() async {
    _status = ProfileStatus.loading;
    notifyListeners();

    var userResult = await sl.get<UserRepo>().getUser();
    userResult.fold(
      (failure) {
        _user = User.empty;
        _errMsg = failure.message;
        _status = ProfileStatus.userNotFound;
      },
      (user) {
        _user = user;
        _status = ProfileStatus.userExists;
      },
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    await sl.get<AuthRepo>().logOut();
    await sl.get<UserRepo>().signOut();
    _user = User.empty;
    _status = ProfileStatus.initial;
    notifyListeners();
  }

  Future<void> deleteProfile() async {
    try {
      await sl.get<AuthRepo>().deleteAccount();
      await sl.get<UserRepo>().deleteAccount();
      _user = User.empty;
      _status = ProfileStatus.initial;
    } catch (e) {
      _status = ProfileStatus.unknown;
      _errMsg = e.toString();
    }
    notifyListeners();
  }
}
