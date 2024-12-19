import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models_repository/models_repository.dart';

class Market extends Equatable {
  final String id;
  final String name;
  final String desc;
  final String hotline;
  final String imgUrl;
  final bool active;
  final TimeOfDay beginTime;
  final TimeOfDay endTime;
  final Location location;

  const Market({
    required this.id,
    required this.name,
    required this.desc,
    required this.hotline,
    required this.imgUrl,
    required this.active,
    required this.location,
    required this.beginTime,
    required this.endTime,
  });

  static Market empty = const Market(
    id: '',
    name: '',
    desc: '',
    imgUrl: '',
    hotline: '',
    active: true,
    location: Location.empty,
    beginTime: TimeOfDay(hour: 0, minute: 0),
    endTime: TimeOfDay(hour: 0, minute: 0),
  );

  Market copyWith({
    String? id,
    String? name,
    String? desc,
    String? hotline,
    String? imgUrl,
    bool? active,
    Location? location,
    TimeOfDay? beginTime,
    TimeOfDay? endTime,
  }) =>
      Market(
        id: id ?? this.id,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        hotline: hotline ?? this.hotline,
        imgUrl: imgUrl ?? this.imgUrl,
        active: active ?? this.active,
        location: location ?? this.location,
        beginTime: beginTime ?? this.beginTime,
        endTime: endTime ?? this.endTime,
      );

  factory Market.fromDoc(String marketId, Map<String, dynamic> marketDoc) =>
      Market(
        id: marketId,
        name: marketDoc['name'],
        desc: marketDoc['desc'],
        hotline: marketDoc['hotline'],
        imgUrl: marketDoc['imgUrl'],
        active: marketDoc['active'],
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
        'desc': desc,
        'hotline': hotline,
        'imgUrl': imgUrl,
        'active': active,
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
    return '\n\tName: $name ::\n\tHotline: $hotline\n\tDescription: $desc\n\tImage Url: $imgUrl\n\tBeginTime: ${beginTime.hour}:${beginTime.minute} ${beginTime.period.name}\n\tEndTime: ${endTime.hour}:${endTime.minute} ${endTime.period.name}\n\tAddress: ${location.latitude}, ${location.longitude}\nActive: $active';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      desc,
      hotline,
      imgUrl,
      active,
      location,
      beginTime,
      endTime,
    ];
  }
}
