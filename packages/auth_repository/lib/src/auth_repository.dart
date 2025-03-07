import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:models_repository/models_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeErrorGetter {
  static String epRegisterError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'هذا الحساب موقوف';
      case 'email-already-in-use':
        return 'يوجد حساب بالفعل لهذا البريد الإلكتروني';
      case 'operation-not-allowed':
        return 'غير مسموح بتسجيل الدخول لهذا الحساب';
      case 'weak-password':
        return 'الرجاء إدخال كلمة مرور قوية';
      default:
        return 'حدث خطأ أثناء انشاء الحساب';
    }
  }

  static String epLoginError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'هذا الحساب موقوف';
      case 'user-not-found':
        return 'هذا الحساب غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحه';
      default:
        return 'حدث خطأ أثناء تسجيل الدخول';
    }
  }

  static String googleLoginError(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return 'الحساب موجود ببيانات اعتماد مختلفة';
      case 'invalid-credential':
        return 'هذا الحساب موقوف';
      case 'operation-not-allowed':
        return 'غير مسموح بتسجيل الدخول لهذا الحساب';
      case 'user-disabled':
        return 'هذا الحساب موقوف';
      case 'user-not-found':
        return 'هذا الحساب غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحه';
      default:
        return 'حدث خطأ أثناء تسجيل الدخول بحساب جوجل';
    }
  }
}

class AuthRepository {
  final FirebaseAuth _fireAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _sharedPref;
  final Dio _dio;
  String? _userId;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    GoogleSignIn? googleSignIn,
    required FirebaseFirestore firestore,
    required SharedPreferences sharedPreferences,
    required Dio dio,
  })  : _fireAuth = firebaseAuth,
        _firestore = firestore,
        _dio = dio,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _sharedPref = sharedPreferences;

  bool get userExists => _userId != null;

  Future<String?> get userId async {
    _userId = _sharedPref.getString('userId');
    if (_userId == null || _userId == '' || _userId?.isEmpty == true)
      return null;
    return _userId;
  }

  Future<String> sendOTPMessage(String phone) async {
    try {
      AppLogs.debug("Starting to send OTP Message ...");
      Response response = await _dio.post(
        'https://beon.chat/api/send/message/otp',
        options: Options(headers: {'beon-token': 'l059YhFIxnufsItml977'}),
        data: FormData.fromMap({
          'phoneNumber': '+2$phone',
          'name': 'Elkosh',
          'type': 'sms',
          'otp_length': '6',
          'lang': 'ar',
          'reference': '123',
        }),
      );
      if (response.data['status'] == 200) {
        AppLogs.success("OTP Message sent successfully...");
        return response.data['data'];
      } else {
        AppLogs.error("OTP Message sent failed...");
        throw Exception(response.data['message']);
      }
    } catch (e) {
      AppLogs.error(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> isUserBlockedByEmailOrPhone(
      String email, String phoneNumber) async {
    try {
      // Check if the email is blocked
      final emailQuery = await _firestore
          .collection('blockedUsers')
          .where('email', isEqualTo: email)
          .get();

      // Check if the phone number is blocked
      final phoneQuery = await _firestore
          .collection('blockedUsers')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      // If either email or phone number is blocked, return true
      return emailQuery.docs.isNotEmpty || phoneQuery.docs.isNotEmpty;
    } catch (e) {
      print('Error checking blocked user: $e');
      throw Exception("حدث خطأ أثناء التحقق من حالة الحظر");
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      bool isBlocked = await isUserBlockedByEmailOrPhone(email, phone);
      if (isBlocked) {
        throw Exception("الحساب محظور بسبب البريد الإلكتروني أو رقم الهاتف");
      }

      UserCredential userCredentials =
          await _fireAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firestore
          .collection(Constants.userCol)
          .doc(userCredentials.user?.uid)
          .set({
        'name': name,
        'phone': phone,
        'email': email,
        'userType': "consumer",
        'active': true,
        'token': '',
      });
      await _sharedPref.setString('userId', userCredentials.user?.uid ?? '');
    } on FirebaseAuthException catch (e) {
      AppLogs.error(e.toString());
      throw Exception(CodeErrorGetter.epRegisterError(e.code));
    } catch (_) {
      throw Exception("حدث خطأ أثناء انشاء الحساب");
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await _fireAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      AppLogs.error(e.toString());
      throw Exception(CodeErrorGetter.googleLoginError(e.code));
    } catch (_) {
      throw Exception("حدث خطأ اثناء تسجيل الدخول الى حساب جوجل");
    }
  }

  Future<String> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredentials =
          await _fireAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _userId = userCredentials.user?.uid;
      final userDoc =
          await _firestore.collection(Constants.userCol).doc(_userId).get();
      if (userDoc.data()?['active'] == false) throw "الحساب موقوف";
      await _sharedPref.setString('userId', _userId ?? '');
      return _userId ?? '';
    } on FirebaseAuthException catch (e) {
      AppLogs.error(e.toString());
      throw Exception(CodeErrorGetter.epLoginError(e.code));
    } catch (e) {
      AppLogs.error(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      _userId = null;
      await _sharedPref.remove('userId');
      await Future.wait([
        _fireAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw Exception("حدث خطأ اثناء تسجيل الخروج");
    }
  }

  Future<void> deleteAccount() async {
    try {
      _userId = null;
      await _sharedPref.remove('userId');
      await Future.wait([
        _fireAuth.currentUser!.delete(),
      ]);
    } catch (e) {
      AppLogs.error(e.toString());
      throw Exception("حدث خطأ اثناء حذف حسابك");
    }
  }
}
