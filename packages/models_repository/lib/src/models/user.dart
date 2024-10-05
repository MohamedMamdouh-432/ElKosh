import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:models_repository/models_repository.dart';

UserType getUserType(String userType) {
  switch (userType) {
    case "consumer":
      return UserType.consumer;
    case "seller":
      return UserType.seller;
    case "delivery":
      return UserType.delivery;
    default:
      return UserType.admin;
  }
}

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.userType,
  });

  static const empty = User(
    id: '',
    email: '',
    name: '',
    phone: '',
    userType: UserType.consumer,
  );

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  static User fromDoc(DocumentSnapshot userDoc) {
    return User(
      id: userDoc.id,
      email: userDoc['email'],
      name: userDoc['name'],
      phone: userDoc['phone'],
      userType: getUserType(userDoc['userType'] ?? 'consumer'),
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserType? userType,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
    );
  }
  
  @override
  String toString() {
    return 'Id: $id\nName: $name\nEmail: $email\nPhone: $phone\nUser Type: $userType\n';
  }

  @override
  List<Object?> get props => [
        email,
        id,
        name,
        phone,
        userType,
      ];
}
