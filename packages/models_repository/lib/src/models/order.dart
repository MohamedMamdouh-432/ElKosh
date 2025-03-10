import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:models_repository/models_repository.dart';

part 'order.g.dart';

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

@HiveType(typeId: 4)
class UserOrder extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int code;

  @HiveField(2)
  final double total;

  @HiveField(3)
  final String userId;

  @HiveField(4)
  final OrderStatus status;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final Location location;

  @HiveField(7)
  final Map<Ad, int> ads;

  @HiveField(8)
  final Map<Product, int> items;

  const UserOrder({
    required this.id,
    required this.code,
    required this.total,
    required this.items,
    required this.ads,
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
    items: const {},
    ads: const {},
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
    Map<Product, int> items,
    Map<Ad, int> ads,
    String id,
  ) =>
      UserOrder(
        id: id,
        userId: map['userId'],
        items: items,
        ads: ads,
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
    Map<Product, int>? items,
    Map<Ad, int>? ads,
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
      items: items ?? this.items,
      ads: ads ?? this.ads,
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
      ads,
      items,
      userId,
      status,
      createdAt,
      location,
    ];
  }
}
