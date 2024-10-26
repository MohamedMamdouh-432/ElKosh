import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final String desc;
  final String imgUrl;
  final double price;
  final String unit;
  final double unitVal;
  final double quantity;
  final double discount;

  const Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.quantity,
    required this.imgUrl,
    required this.categoryId,
    this.unit = 'كيلو',
    required this.unitVal,
    required this.discount,
  });

  static Product empty = const Product(
    id: '',
    name: '',
    desc: '',
    price: 0.0,
    quantity: 0.0,
    imgUrl: '',
    categoryId: '',
    unitVal: 0,
    discount: 0,
  );

  factory Product.fromDoc(String productId, Map<String, dynamic> productDoc) =>
      Product(
        id: productId,
        name: productDoc['name'],
        desc: productDoc['desc'],
        imgUrl: productDoc['imgUrl'],
        categoryId: productDoc['categoryId'],
        unit: productDoc['unit'],
        price: productDoc['price'].toDouble(),
        quantity: productDoc['quantity'].toDouble(),
        unitVal: productDoc['unitVal'].toDouble(),
        discount: productDoc['discount'].toDouble(),
      );

  Map<String, dynamic> toDoc() => {
        'name': name,
        'desc': desc,
        'price': price,
        'quantity': quantity,
        'imgUrl': imgUrl,
        'categoryId': categoryId,
        'unit': unit,
        'unitVal': unitVal,
        'discount': discount,
      };

  Product copyWith({
    String? id,
    String? name,
    String? desc,
    double? price,
    double? quantity,
    String? categoryId,
    String? imgUrl,
    String? unit,
    double? unitVal,
    double? discount,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        categoryId: categoryId ?? this.categoryId,
        imgUrl: imgUrl ?? this.imgUrl,
        unit: unit ?? 'packet',
        unitVal: unitVal ?? this.unitVal,
        discount: discount ?? this.discount,
      );

  @override
  String toString() {
    return '\tName: $name ::\n\tDescription: $desc\n\tPrice: $price\n\tStock Quantity: $quantity\n\tImgUrl: $imgUrl\n\tUnit: $unit\n\tUnit Value: $unitVal\nDiscount; $discount';
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
      unit,
      unitVal,
      discount,
    ];
  }
}
