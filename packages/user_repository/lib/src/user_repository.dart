import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:models_repository/models_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  User? _user;
  String? _userId;
  final FirebaseFirestore _firestore;
  final SharedPreferences _sharedPref;

  UserRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required SharedPreferences sharedPreferences,
  })  : _firestore = firestore,
        _sharedPref = sharedPreferences;

  Future<void> setUserID(String userId) async {
    _userId = userId;
    await _sharedPref.setString('userId', _userId ?? '');
  }

  Future<Either<Failure, User>> getUser() async {
    try {
      _userId = _sharedPref.getString('userId');
      if (_userId == null || _userId?.isEmpty == true)
        return const Left(Failure("لم تقم بتسجيل الدخول"));
      final userDoc =
          await _firestore.collection(Constants.userCol).doc(_userId).get();
      if (userDoc.exists)
        _user = User.fromDoc(userDoc.id, userDoc.data() ?? {});
      await _sharedPref.setString('userId', _userId ?? '');
      return _user != null
          ? Right(_user ?? User.empty)
          : const Left(Failure("المستخدم غير موجود"));
    } catch (e) {
      AppLogs.error(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<void> signOut() async {
    _user = null;
    _userId = null;
    await _sharedPref.remove('userId');
  }

  Future<void> deleteAccount() async {
    await _firestore.collection(Constants.userCol).doc(_userId ?? '').delete();
    _user = _userId = null;
    await _sharedPref.remove('userId');
  }
}
