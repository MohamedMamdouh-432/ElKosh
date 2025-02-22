import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'product.g.dart';

@HiveType(typeId: 5)
class Product extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String desc;

  @HiveField(3)
  final String imgUrl;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final String unitDesc;

  @HiveField(6)
  final double quantity;

  @HiveField(7)
  final double updatedPrice;

  @HiveField(8)
  final String marketId;

  @HiveField(9)
  final String categoryId;

  const Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.quantity,
    required this.imgUrl,
    required this.unitDesc,
    required this.updatedPrice,
    required this.categoryId,
    required this.marketId,
  });

  static Product empty = const Product(
    id: '',
    name: '',
    desc: '',
    price: 0.0,
    quantity: 0.0,
    imgUrl: '',
    updatedPrice: 0,
    categoryId: '',
    marketId: '',
    unitDesc: '',
  );

  factory Product.fromDoc(String productId, Map<String, dynamic> productDoc) =>
      Product(
        id: productId,
        name: productDoc['name'],
        desc: productDoc['desc'],
        imgUrl: productDoc['imgUrl'],
        unitDesc: productDoc['unitDesc'],
        categoryId: productDoc['categoryId'],
        marketId: productDoc['marketId'],
        price: productDoc['price'].toDouble(),
        quantity: productDoc['quantity'].toDouble(),
        updatedPrice: (productDoc['updatedPrice'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toDoc() => {
        'name': name,
        'desc': desc,
        'price': price,
        'quantity': quantity,
        'imgUrl': imgUrl,
        'categoryId': categoryId,
        'marketId': marketId,
        'unitDesc': unitDesc,
        'updatedPrice': updatedPrice,
      };

  @override
  List<Object> get props => [
        id,
        name,
        desc,
        price,
        quantity,
        imgUrl,
        categoryId,
        marketId,
        unitDesc,
        updatedPrice
      ];
}
