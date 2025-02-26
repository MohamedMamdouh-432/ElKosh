import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:models_repository/models_repository.dart';

part 'market.g.dart';

@HiveType(typeId: 3)
class Market extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String desc;

  @HiveField(3)
  final String hotline;

  @HiveField(4)
  final String imgUrl;

  @HiveField(5)
  final bool active;

  @HiveField(6)
  final DayTime beginTime;

  @HiveField(7)
  final DayTime endTime;

  @HiveField(8)
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
    beginTime: DayTime(hour: 0, minute: 0, period: 'am'),
    endTime: DayTime(hour: 0, minute: 0, period: 'pm'),
  );

  Market copyWith({
    String? id,
    String? name,
    String? desc,
    String? hotline,
    String? imgUrl,
    bool? active,
    Location? location,
    DayTime? beginTime,
    DayTime? endTime,
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
        beginTime: DayTime.fromTimeOfDay(TimeOfDay(
          hour: marketDoc['beginTime']['hour'],
          minute: marketDoc['beginTime']['minute'],
        )),
        endTime: DayTime.fromTimeOfDay(TimeOfDay(
          hour: marketDoc['endTime']['hour'],
          minute: marketDoc['endTime']['minute'],
        )),
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
    return '\n\tName: $name ::\n\tHotline: $hotline\n\tDescription: $desc\n\tImage Url: $imgUrl\n\tBeginTime: ${beginTime.hour}:${beginTime.minute} ${beginTime.period}\n\tEndTime: ${endTime.hour}:${endTime.minute} ${endTime.period}\n\tAddress: ${location.latitude}, ${location.longitude}\nActive: $active';
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
