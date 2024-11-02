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
  final String marketId;
  final String marketName;
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
    required this.marketId,
    required this.userId,
    required this.status,
    required this.marketName,
    required this.createdAt,
    required this.location,
  });

  static UserOrder empty = UserOrder(
    id: '',
    code: 0,
    status: OrderStatus.pending,
    shopping: const {},
    total: 0,
    createdAt: DateTime(0),
    marketId: '',
    userId: '',
    marketName: "",
    location: Location.empty,
  );

  factory UserOrder.fromDoc(
    Map<String, dynamic> map,
    Map<Product, int> shoppingList,
    String id,
  ) =>
      UserOrder(
        id: id,
        code: map['code'].toInt(),
        total: map['total'].toDouble(),
        shopping: shoppingList,
        status: getOrderStatus(map['status']),
        createdAt: map['createdAt'].toDate(),
        marketId: map['marketId'],
        userId: map['userId'],
        marketName: map['marketName'],
        location: Location.fromJson(map['location']),
      );

  Map<String, dynamic> toDoc(shoppingMap) => {
        'price': total,
        'status': status.name,
        'createdAt': createdAt,
        'marketId': marketId,
        'userId': userId,
        'shoppings': shoppingMap,
        'marketName': marketName,
        'location': location.toJson(),
      };

  UserOrder copyWith({
    String? id,
    int? code,
    double? total,
    Map<Product, int>? shopping,
    String? marketId,
    String? userId,
    OrderStatus? status,
    DateTime? createdAt,
    String? marketName,
    Location? location,
  }) {
    return UserOrder(
      id: id ?? this.id,
      code: code ?? this.code,
      total: total ?? this.total,
      shopping: shopping ?? this.shopping,
      marketId: marketId ?? this.marketId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      marketName: marketName ?? this.marketName,
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
      marketId,
      userId,
      status,
      createdAt,
      marketName,
      location,
    ];
  }
}
