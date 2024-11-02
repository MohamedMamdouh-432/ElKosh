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

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.userType,
    required this.active,
  });

  static const empty = User(
    id: '',
    email: '',
    name: '',
    phone: '',
    active: true,
    userType: UserType.consumer,
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
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    bool? active,
    UserType? userType,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      active: active ?? this.active,
      userType: userType ?? this.userType,
    );
  }

  @override
  String toString() {
    return 'Id: $id\nName: $name\nEmail: $email\nPhone: $phone\nUser Type: $userType\nActive: $active';
  }

  @override
  List<Object?> get props => [
        email,
        id,
        name,
        phone,
        active,
        userType,
      ];
}
