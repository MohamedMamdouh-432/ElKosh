import 'package:equatable/equatable.dart';

class Offer extends Equatable {
  final String id;
  final String title;
  final String imgUrl;

  const Offer({
    required this.id,
    required this.title,
    required this.imgUrl,
  });

  static Offer empty = const Offer(
    id: '',
    title: '',
    imgUrl: '',
  );

  factory Offer.fromDoc(String id, Map<String, dynamic> offerDoc) => Offer(
        id: id,
        title: offerDoc['title'],
        imgUrl: offerDoc['imgUrl'],
      );

  Map<String, dynamic> toDoc() => {
        'title': title,
        'imgUrl': imgUrl,
      };

  Offer copyWith({
    String? id,
    String? title,
    String? imgUrl,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  @override
  String toString() => 'Offer :: \nid: $id\ntitle: $title\nimgUrl: $imgUrl';

  @override
  List<Object> get props => [id, title, imgUrl];
}
