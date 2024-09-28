import 'package:equatable/equatable.dart';
import 'package:models_repository/models_repository.dart';

OrderStatus convertToState(String stateValue) {
  switch (stateValue) {
    case "Pending":
      return OrderStatus.pending;
    case "Shipped":
      return OrderStatus.shipped;
    case "Delivered":
      return OrderStatus.delivered;
    default:
      return OrderStatus.cancelled;
  }
}

class UserOrder extends Equatable {
  final String id;
  final double total;
  final Map<Product, int> shopping;
  final String marketId;
  final String userId;
  final String deliveryId;
  final OrderStatus status;
  final DateTime createdAt;

  const UserOrder({
    required this.id,
    required this.total,
    required this.shopping,
    required this.marketId,
    required this.userId,
    required this.deliveryId,
    required this.status,
    required this.createdAt,
  });

  static UserOrder empty = UserOrder(
    id: '',
    status: OrderStatus.pending,
    shopping: const {},
    total: 0,
    createdAt: DateTime(0),
    deliveryId: '',
    marketId: '',
    userId: '',
  );

  factory UserOrder.fromDoc(
    Map<String, dynamic> map,
    Map<Product, int> shoppingList,
    String id,
  ) {
    return UserOrder(
      id: id,
      total: map['price'],
      shopping: shoppingList,
      status: convertToState(map['status']),
      createdAt: DateTime.parse(map['createdAt']),
      marketId: map['marketId'],
      userId: map['userId'],
      deliveryId: map['deliveryId'],
    );
  }

  UserOrder copyWith({
    String? id,
    double? total,
    Map<Product, int>? shopping,
    String? marketId,
    String? userId,
    String? deliveryId,
    OrderStatus? status,
    DateTime? createdAt,
  }) {
    return UserOrder(
      id: id ?? this.id,
      total: total ?? this.total,
      shopping: shopping ?? this.shopping,
      marketId: marketId ?? this.marketId,
      userId: userId ?? this.userId,
      deliveryId: deliveryId ?? this.deliveryId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      total,
      shopping,
      marketId,
      userId,
      deliveryId,
      status,
      createdAt,
    ];
  }
}
