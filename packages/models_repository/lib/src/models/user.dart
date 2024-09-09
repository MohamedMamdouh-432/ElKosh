import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String id;
  final String name;
  final String imgUrl;
  final String phoneNumber;

  final bool isAdmin;
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.imgUrl,
    required this.phoneNumber,
    required this.isAdmin,
  });

  static const empty = User(
    id: '',
    email: '',
    name: '',
    imgUrl: '',
    phoneNumber: '',
    isAdmin: false,
  );

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  static User fromUserDoc(DocumentSnapshot userDoc) {
    return User(
      id: userDoc.id,
      email: userDoc['email'],
      name: userDoc['name'],
      imgUrl: userDoc['imgUrl'],
      phoneNumber: userDoc['phoneNumber'],
      isAdmin: userDoc['isAdmin'] ?? false,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? imgUrl,
    String? phoneNumber,
    bool? isAdmin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  List<Object?> get props => [
        email,
        id,
        name,
        imgUrl,
        phoneNumber,
        isAdmin,
      ];
}


extension UserX on User {
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'imgUrl': imgUrl,
      'phoneNumber': phoneNumber,
      'isAdmin': isAdmin,
    };
  }
}

class UserError extends Equatable {
  final String message;

  const UserError({required this.message});
  static const userDoesNotExist = UserError(message: 'User does not exist');

  @override
  List<Object?> get props => [message];
}
