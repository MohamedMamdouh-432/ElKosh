import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:models_repository/models_repository.dart';

part 'shopping_item.g.dart';

@HiveType(typeId: 7)
class ShoppingItem extends Equatable {
  @HiveField(0)
  final Product product;
  @HiveField(1)
  final int quantity;
  @HiveField(2)
  final double price;

  const ShoppingItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  static ShoppingItem empty = ShoppingItem(
    product: Product.empty,
    quantity: 0,
    price: 0.0,
  );

  ShoppingItem copyWith({
    Product? product,
    int? quantity,
    double? price,
  }) {
    return ShoppingItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, List> toDoc() => {
        product.id: [quantity, price],
      };

  factory ShoppingItem.fromDoc(List doc, Product product) => ShoppingItem(
        product: product,
        quantity: doc[0].toInt(),
        price: doc[1].toDouble(),
      );

  @override
  String toString() => '''
      Product : ${product.name}
      Quantity: $quantity
      Price: $price
    ''';

  @override
  List<Object> get props => [product, quantity, price];
}
