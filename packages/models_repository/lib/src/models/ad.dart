import 'package:equatable/equatable.dart';
import 'package:models_repository/models_repository.dart';

class Ad extends Equatable {
  final String id;
  final String title;
  final String imgUrl;
  final double total;
  final List<Offer> offers;

  const Ad({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.total,
    required this.offers,
  });

  static Ad empty = const Ad(
    id: '',
    title: '',
    imgUrl: '',
    total: 0,
    offers: [],
  );

  Ad copyWith({
    String? id,
    String? title,
    String? imgUrl,
    double? total,
    List<Offer>? offers,
  }) {
    return Ad(
      id: id ?? this.id,
      title: title ?? this.title,
      imgUrl: imgUrl ?? this.imgUrl,
      total: total ?? this.total,
      offers: offers ?? this.offers,
    );
  }

  factory Ad.fromDoc(
    String adId,
    List<Offer> offers,
    Map<String, dynamic> adDoc,
  ) =>
      Ad(
        id: adId,
        title: adDoc['title'],
        imgUrl: adDoc['imgUrl'],
        total: adDoc['total'].toDouble(),
        offers: offers,
      );

  Map<String, dynamic> toDoc() => {
        'title': title,
        'imgUrl': imgUrl,
        'total': total,
        'offers': offers.map((offer) => offer.toJson()).toList(),
      };

  @override
  List<Object> get props => [
        title,
        imgUrl,
        total,
        offers,
      ];
}
