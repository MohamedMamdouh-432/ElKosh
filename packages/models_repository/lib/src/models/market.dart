import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models_repository/models_repository.dart';

class Market extends Equatable {
  final String id;
  final String sellerId;
  final String name;
  final String desc;
  final String hotline;
  final String imgUrl;
  final TimeOfDay beginTime;
  final TimeOfDay endTime;
  final Location location;

  const Market({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.desc,
    required this.hotline,
    required this.imgUrl,
    required this.location,
    required this.beginTime,
    required this.endTime,
  });

  static Market empty = const Market(
    id: '',
    sellerId: '',
    name: '',
    desc: '',
    imgUrl: '',
    hotline: '',
    location: Location.empty,
    beginTime: TimeOfDay(hour: 0, minute: 0),
    endTime: TimeOfDay(hour: 0, minute: 0),
  );

  Market copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? desc,
    String? hotline,
    String? imgUrl,
    Location? location,
    TimeOfDay? beginTime,
    TimeOfDay? endTime,
  }) =>
      Market(
        id: id ?? this.id,
        sellerId: sellerId ?? this.sellerId,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        hotline: hotline ?? this.hotline,
        imgUrl: imgUrl ?? this.imgUrl,
        location: location ?? this.location,
        beginTime: beginTime ?? this.beginTime,
        endTime: endTime ?? this.endTime,
      );

  factory Market.fromDoc(String marketId, Map<String, dynamic> marketDoc) =>
      Market(
        id: marketId,
        sellerId: marketDoc['sellerId'],
        name: marketDoc['name'],
        desc: marketDoc['desc'],
        hotline: marketDoc['hotline'],
        imgUrl: marketDoc['imgUrl'],
        location: Location.fromJson(marketDoc['location']),
        beginTime: TimeOfDay(
            hour: marketDoc['beginTime']['hour'],
            minute: marketDoc['beginTime']['minute']),
        endTime: TimeOfDay(
            hour: marketDoc['endTime']['hour'],
            minute: marketDoc['endTime']['minute']),
      );

  Map<String, dynamic> toDoc() => {
        'name': name,
        'sellerId': sellerId,
        'desc': desc,
        'hotline': hotline,
        'imgUrl': imgUrl,
        'location': location.toJson(),
        'beginTime': {
          'hour': beginTime.hour,
          'minute': beginTime.minute,
        },
        'endTime': {
          'hour': endTime.hour,
          'minute': endTime.minute,
        },
      };

  @override
  String toString() {
    return '\n\tName: $name ::\n\tHotline: $hotline\n\tDescription: $desc\n\tImage Url: $imgUrl\n\tBeginTime: ${beginTime.hour}:${beginTime.minute} ${beginTime.period.name}\n\tEndTime: ${endTime.hour}:${endTime.minute} ${endTime.period.name}\n\tAddress: ${location.latitude}, ${location.longitude}';
  }

  @override
  List<Object> get props {
    return [
      id,
      sellerId,
      name,
      desc,
      hotline,
      imgUrl,
      location,
      beginTime,
      endTime,
    ];
  }
}
