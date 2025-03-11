import 'package:elkosh/repos/submodels/submodels.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'ad.g.dart';

@HiveType(typeId: 1)
class Ad extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imgUrl;
  @HiveField(3)
  final double total;
  @HiveField(4)
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
