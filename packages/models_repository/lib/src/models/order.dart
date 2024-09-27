import 'package:equatable/equatable.dart';
import 'package:models_repository/models_repository.dart';

class Order extends Equatable {
  final String id;
  final double total;
  final Map<Product, int> shopping;
  final String marketId;
  final String userId;
  final String deliveryId;
  final OrderStatus status;
  final String createdAt;

  const Order({
    required this.id,
    required this.total,
    required this.shopping,
    required this.marketId,
    required this.userId,
    required this.deliveryId,
    required this.status,
    required this.createdAt,
  });

  Order copyWith({
    String? id,
    double? total,
    Map<Product, int>? shopping,
    String? marketId,
    String? userId,
    String? deliveryId,
    OrderStatus? status,
    String? createdAt,
  }) {
    return Order(
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
