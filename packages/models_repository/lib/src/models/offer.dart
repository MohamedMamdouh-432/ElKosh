import 'package:equatable/equatable.dart';

class Advertisment extends Equatable {
  final String id;
  final String title;
  final String imgUrl;

  const Advertisment({
    required this.id,
    required this.title,
    required this.imgUrl,
  });

  static Advertisment empty = const Advertisment(
    id: '',
    title: '',
    imgUrl: '',
  );

  factory Advertisment.fromDoc(String id, Map<String, dynamic> offerDoc) =>
      Advertisment(
        id: id,
        title: offerDoc['title'],
        imgUrl: offerDoc['imgUrl'],
      );

  Map<String, dynamic> toDoc() => {
        'title': title,
        'imgUrl': imgUrl,
      };

  Advertisment copyWith({
    String? id,
    String? title,
    String? imgUrl,
  }) {
    return Advertisment(
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
