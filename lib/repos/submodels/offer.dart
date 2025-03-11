import 'package:elkosh/repos/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'offer.g.dart';

@HiveType(typeId: 8)
class Offer extends Equatable {
  @HiveField(0)
  final int quantity;
  @HiveField(1)
  final double price;
  @HiveField(2)
  final Product product;

  const Offer({
    required this.product,
    required this.quantity,
    required this.price,
  });

  static Offer empty = Offer(
    price: 0,
    quantity: 0,
    product: Product.empty,
  );

  bool get isValid => quantity > 0 && price > 0 && product != Product.empty;

  Offer copyWith({
    Product? product,
    int? quantity,
    double? price,
  }) =>
      Offer(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
      );

  factory Offer.fromDoc(Map<String, dynamic> offerDoc, Product product) =>
      Offer(
        product: product,
        price: offerDoc['price'].toDouble(),
        quantity: offerDoc['quantity'].toInt(),
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'quantity': quantity,
        'productId': product.id,
      };

  @override
  String toString() {
    return ''' Offer::
        product: ${product.name}, 
        quantity: $quantity, 
        price: $price
      ''';
  }

  @override
  List<Object> get props => [product, quantity, price];
}
