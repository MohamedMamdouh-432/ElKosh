import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String marketId;
  final String name;
  final String desc;
  final String imgUrl;
  final double price;
  final String unit;
  final double unitVal;
  final double quantity;

  const Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.quantity,
    required this.imgUrl,
    required this.marketId,
    this.unit = 'kg',
    required this.unitVal,
  });

  static Product empty = const Product(
    id: '',
    name: '',
    desc: '',
    price: 0.0,
    quantity: 0.0,
    imgUrl: '',
    marketId: '',
    unitVal: 0,
  );

  factory Product.fromDoc(String productId, Map<String, dynamic> productDoc) =>
      Product(
        id: productId,
        name: productDoc['name'],
        desc: productDoc['desc'],
        imgUrl: productDoc['imgUrl'],
        marketId: productDoc['marketId'],
        unit: productDoc['unit'],
        price: productDoc['price'].toDouble(),
        quantity: productDoc['quantity'].toDouble(),
        unitVal: productDoc['unitVal'].toDouble(),
      );

  Map<String, dynamic> toDoc() => {
        'name': name,
        'desc': desc,
        'price': price,
        'quantity': quantity,
        'imgUrl': imgUrl,
        'marketId': marketId,
        'unit': unit,
        'unitVal': unitVal
      };

  Product copyWith({
    String? id,
    String? name,
    String? desc,
    double? price,
    double? quantity,
    String? marketId,
    String? imgUrl,
    String? unit,
    double? unitVal,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        marketId: marketId ?? this.marketId,
        imgUrl: imgUrl ?? this.imgUrl,
        unit: unit ?? 'packet',
        unitVal: unitVal ?? this.unitVal,
      );

  @override
  String toString() {
    return 'Name: $name ::\nDescription: $desc\nPrice: $price\nStock Quantity: $quantity\nImgUrl: $imgUrl\nUnit: $unit\nUnit Value: $unitVal\n';
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
      marketId,
      unit,
      unitVal,
    ];
  }
}
