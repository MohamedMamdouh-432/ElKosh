import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models_repository/models_repository.dart';

OrderStatus getOrderStatus(String stateValue) {
  switch (stateValue) {
    case "pending":
      return OrderStatus.pending;
    case "shipped":
      return OrderStatus.shipped;
    case "delivered":
      return OrderStatus.delivered;
    case "refused":
      return OrderStatus.refused;
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
  final bool isAd;
  final List<ShoppingItem> shopping;

  const UserOrder({
    required this.id,
    required this.code,
    required this.total,
    required this.shopping,
    required this.isAd,
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
    shopping: const [],
    isAd: false,
    createdAt: DateTime(0),
    location: Location.empty,
    status: OrderStatus.pending,
  );

  Color get color => status == OrderStatus.pending
      ? Colors.blueGrey
      : status == OrderStatus.shipped
          ? Colors.teal
          : status == OrderStatus.delivered
              ? Colors.green
              : status == OrderStatus.refused
                  ? Colors.deepPurple
                  : Colors.red;

  String get content => status == OrderStatus.pending
      ? 'تم تسجيل الطلب'
      : status == OrderStatus.shipped
          ? 'تم شحن الطلب'
          : status == OrderStatus.delivered
              ? 'تم تسليم الطلب'
              : status == OrderStatus.refused
                  ? 'تم رفض استلام الطلب'
                  : 'تم الغاء الطلب';

  factory UserOrder.fromDoc(
    Map<String, dynamic> map,
    List<ShoppingItem> shoppingList,
    String id,
  ) =>
      UserOrder(
        id: id,
        userId: map['userId'],
        shopping: shoppingList,
        code: map['code'].toInt(),
        total: map['total'].toDouble(),
        createdAt: map['createdAt'].toDate(),
        isAd: map['isAd'],
        status: getOrderStatus(map['status']),
        location: Location.fromJson(map['location']),
      );

  UserOrder copyWith({
    String? id,
    int? code,
    double? total,
    List<ShoppingItem>? shopping,
    String? userId,
    bool? isAd,
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
      isAd: isAd ?? this.isAd,
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
      isAd,
      shopping,
      userId,
      status,
      createdAt,
      location,
    ];
  }
}
