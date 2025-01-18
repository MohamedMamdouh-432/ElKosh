// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:models_repository/models_repository.dart';

// class UserRepository {
//   final FirebaseFirestore _firestore;

//   UserRepository(this._firestore);

//   Future<void> saveUser(User user) async {
//     try {
//       await _firestore.collection('users').doc(user.id).set({
//         'email': user.email,
//         'name': user.name,
//         'phone': user.phone,
//         'active': user.active,
//         'userType':
//             user.userType.toString().split('.').last, // Convert enum to string
//         'deviceToken': user.token,
//       });
//       print('User saved successfully');
//     } catch (e) {
//       print('Error saving user: $e');
//     }
//   }

//   Future<void> updateDeviceToken(String userId, String deviceToken) async {
//     try {
//       await _firestore.collection('users').doc(userId).update({
//         'deviceToken': deviceToken,
//       });
//       print('Device token updated successfully');
//     } catch (e) {
//       print('Error updating device token: $e');
//     }
//   }
// }
