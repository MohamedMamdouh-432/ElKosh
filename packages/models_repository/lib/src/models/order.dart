import 'package:equatable/equatable.dart';
import 'package:models_repository/models_repository.dart';

OrderStatus getOrderStatus(String stateValue) {
  switch (stateValue) {
    case "pending":
      return OrderStatus.pending;
    case "shipped":
      return OrderStatus.shipped;
    case "delivered":
      return OrderStatus.delivered;
    default:
      return OrderStatus.cancelled;
  }
}

class UserOrder extends Equatable {
  final String id;
  final int code;
  final double total;
  final String userId;
  final OrderStatus status;
  final DateTime createdAt;
  final Location location;
  final Map<Product, int> shopping;

  const UserOrder({
    required this.id,
    required this.code,
    required this.total,
    required this.shopping,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.location,
  });

  static UserOrder empty = UserOrder(
    id: '',
    code: 0,
    total: 0,
    userId: '',
    shopping: const {},
    createdAt: DateTime(0),
    location: Location.empty,
    status: OrderStatus.pending,
  );

  factory UserOrder.fromDoc(
    Map<String, dynamic> map,
    Map<Product, int> shoppingList,
    String id,
  ) =>
      UserOrder(
        id: id,
        userId: map['userId'],
        shopping: shoppingList,
        code: map['code'].toInt(),
        total: map['total'].toDouble(),
        createdAt: map['createdAt'].toDate(),
        status: getOrderStatus(map['status']),
        location: Location.fromJson(map['location']),
      );

  UserOrder copyWith({
    String? id,
    int? code,
    double? total,
    Map<Product, int>? shopping,
    String? userId,
    OrderStatus? status,
    DateTime? createdAt,
    Location? location,
  }) {
    return UserOrder(
      id: id ?? this.id,
      code: code ?? this.code,
      total: total ?? this.total,
      shopping: shopping ?? this.shopping,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      code,
      total,
      shopping,
      userId,
      status,
      createdAt,
      location,
    ];
  }
}
