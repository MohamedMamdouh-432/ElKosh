import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String imgUrl;
  @HiveField(3)
  final String marketId;

  const Category({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.marketId,
  });

  static Category empty = const Category(
    id: '',
    name: '',
    imgUrl: '',
    marketId: '',
  );

  Category copyWith({
    String? id,
    String? name,
    String? imgUrl,
    String? marketId,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      marketId: marketId ?? this.marketId,
    );
  }

  factory Category.fromDoc(String catId, Map<String, dynamic> catDoc) =>
      Category(
        id: catId,
        name: catDoc['name'],
        imgUrl: catDoc['imgUrl'],
        marketId: catDoc['marketId'],
      );

  @override
  String toString() =>
      '\nCategory :: Name: $name, imgUrl: $imgUrl, MarketId: $marketId';

  @override
  List<Object> get props => [id, name, imgUrl, marketId];
}
