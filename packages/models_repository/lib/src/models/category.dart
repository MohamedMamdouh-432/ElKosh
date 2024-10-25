import 'package:equatable/equatable.dart';

final Map<String, String> cats = {
  'مخبوزات و معجنات':
      'https://firebasestorage.googleapis.com/v0/b/elkoshecommerce.appspot.com/o/categories%2Fc1.png?alt=media&token=0d54fefc-0909-465d-a64a-68c63e51077c',
  'حلويات و ايس كريم':
      'https://firebasestorage.googleapis.com/v0/b/elkoshecommerce.appspot.com/o/categories%2Fc3.png?alt=media&token=f394ef29-aef1-4b16-8c40-290fb77eff56',
  'فاكهه و خضروات':
      'https://firebasestorage.googleapis.com/v0/b/elkoshecommerce.appspot.com/o/categories%2Fc2.png?alt=media&token=f04c95f4-d3e4-48ca-a0ae-04c59d336a31',
  // 'البيض و الجبن و اللحوم': '',
  // 'طعام جاهز': '',
  // 'ألبان': '',
  // 'مجمدات': '',
  // 'لحوم و دواجن و اسماك': '',
  // 'البقالة': '',
  // 'وجبات سريعه': '',
  // 'مشروبات': '',
  // 'مستحضرات التجميل': '',
  // 'مستلزمات منزلية': '',
  // 'منظفات الغسيل': '',
  // 'منظفات المنزل': '',
  // 'مناديل': '',
  // 'العناية الشخصية': '',
  // 'الصحة': '',
  // 'منتجات الأطفال': '',
  // 'مستلزمات الحيوانات': '',
  // 'أدوات مكتبيه و ألعاب': '',
  // 'مستلزمات أخرى': '',
};

class Category extends Equatable {
  final String id;
  final String name;
  final String imgUrl;
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

  Map<String, dynamic> toDoc() => {
        'name': name,
        'imgUrl': imgUrl,
        'marketId': marketId,
      };

  @override
  String toString() =>
      '\nCategory :: Name: $name, imgUrl: $imgUrl, MarketId: $marketId';

  @override
  List<Object> get props => [id, name, imgUrl, marketId];
}
