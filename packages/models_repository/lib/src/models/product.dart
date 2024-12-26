import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String desc;
  final String imgUrl;
  final double price;
  final String unitDesc;
  final double quantity;
  final double updatedPrice;
  final String marketId;
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

  Product copyWith({
    String? id,
    String? name,
    String? desc,
    double? price,
    double? quantity,
    String? categoryId,
    String? marketId,
    String? imgUrl,
    String? unitDesc,
    double? updatedPrice,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        categoryId: categoryId ?? this.categoryId,
        marketId: marketId ?? this.marketId,
        imgUrl: imgUrl ?? this.imgUrl,
        unitDesc: unitDesc ?? this.unitDesc,
        updatedPrice: updatedPrice ?? this.updatedPrice,
      );

  @override
  String toString() {
    return '\tName: $name ::\n\tDescription: $desc\n\tPrice: $price\n\tStock Quantity: $quantity\n\tImgUrl: $imgUrl\n\tUnit Desc: $unitDesc\nUpdatedPrice; $updatedPrice';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      desc,
      price,
      quantity,
      imgUrl,
      categoryId,
      marketId,
      unitDesc,
      updatedPrice,
    ];
  }
}
