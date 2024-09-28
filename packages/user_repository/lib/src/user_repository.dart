import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:models_repository/models_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  User? _user;
  String? _userId;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final SharedPreferences _sharedPreferences;

  UserRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required SharedPreferences sharedPreferences,
  })  : _firestore = firestore,
        _storage = storage,
        _sharedPreferences = sharedPreferences;

  Future<void> setUserID(String userId) async {
    _userId = userId;
    await _sharedPreferences.setString('userId', _userId!);
  }

  Future<Either<UserError, User>> getUser() async {
    _userId = _sharedPreferences.getString('userId');
    log("userId from get user is $_userId  ");
    if (_userId == null || _userId!.isEmpty) {
      return const Left(UserError(message: "Could not find user id"));
    }

    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_userId).get();
      if (userDoc.exists) {
        _user = User.fromUserDoc(userDoc);
      } else {
        log("User does't exist according to the database inside getUser() in user_repository.dart ");
      }
      await _sharedPreferences.setString('userId', _userId!);

      return _user != null
          ? Right(_user!)
          : const Left(UserError.userDoesNotExist);
    } catch (e) {
      return Left(UserError(message: "Error 404! $e"));
    }
  }
  
  Future<void> signOut() async {
    _user = null;
    _userId = null;
    await _sharedPreferences.remove('userId');
  }

  Future<void> deleteAccount() async {
    _storage.ref().child('users').child(_userId!).delete();
    await _firestore.collection('users').doc(_userId!).delete();
    _user = null;
    _userId = null;
    await _sharedPreferences.remove('userId');
  }
}
