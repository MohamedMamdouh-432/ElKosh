import 'package:equatable/equatable.dart';
import 'package:models_repository/models_repository.dart';

UserType getUserType(String userType) {
  switch (userType) {
    case "consumer":
      return UserType.consumer;
    default:
      return UserType.admin;
  }
}

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool active;
  final UserType userType;
  final String token;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.userType,
    required this.active,
    required this.token,
  });

  static const empty = User(
    id: '',
    email: '',
    name: '',
    phone: '',
    active: true,
    userType: UserType.consumer,
    token: '',
  );

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  static User fromDoc(userId, Map<String, dynamic> userDoc) {
    return User(
      id: userId,
      email: userDoc['email'],
      name: userDoc['name'],
      phone: userDoc['phone'],
      active: userDoc['active'],
      userType: getUserType(userDoc['userType'] ?? 'consumer'),
      token: userDoc['token'] ?? '',
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    bool? active,
    UserType? userType,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      active: active ?? this.active,
      userType: userType ?? this.userType,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'Id: $id\nName: $name\nEmail: $email\nPhone: $phone\nUser Type: $userType\nActive: $active\nDevice Token: $token';
  }

  @override
  List<Object?> get props => [
        email,
        id,
        name,
        phone,
        active,
        userType,
        token,
      ];

  //from map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      active: map['active'] ?? false,
      userType: getUserType(map['userType'] ?? 'consumer'),
      token: map['token'] ?? '',
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'active': active,
      'userType': userType.toString().split('.').last,
      'token': token,
    };
  }
}
