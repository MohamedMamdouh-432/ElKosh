import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Market extends Equatable {
  final String id;
  final String name;
  final String desc;
  final String hotline;
  final String imgUrl;
  final GeoPoint address;

  const Market({
    required this.id,
    required this.name,
    required this.desc,
    required this.hotline,
    required this.imgUrl,
    required this.address,
  });

  Market copyWith({
    String? id,
    String? name,
    String? desc,
    String? hotline,
    String? imgUrl,
    GeoPoint? address,
  }) =>
      Market(
        id: id ?? this.id,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        hotline: hotline ?? this.hotline,
        imgUrl: imgUrl ?? this.imgUrl,
        address: address ?? this.address,
      );

  factory Market.fromDoc(String marketId, Map<String, dynamic> marketDoc) =>
      Market(
        id: marketId,
        name: marketDoc['name'],
        desc: marketDoc['desc'],
        hotline: marketDoc['hotline'],
        imgUrl: marketDoc['imgUrl'],
        address: GeoPoint(
          marketDoc['address'].latitude,
          marketDoc['address'].longitude,
        ),
      );

  Map<String, dynamic> toDoc() => {
        'name': name,
        'desc': desc,
        'hotline': hotline,
        'imgUrl': imgUrl,
        'address': address,
      };

  @override
  String toString() {
    return '$name Market ::\nDoc Id: $id\nImage Url: $imgUrl\nHotline: $hotline\nDescription: $desc\nAddress: ${address.latitude}, ${address.longitude}\n';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      desc,
      hotline,
      imgUrl,
      address,
    ];
  }
}
