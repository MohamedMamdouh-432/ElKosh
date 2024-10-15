import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage fireStorage;
  final SharedPreferences sharedPref;
  
  AdminRepository({
    required this.firestore,
    required this.fireStorage,
    required this.sharedPref,
  });
}
