import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'day_time.g.dart';

@HiveType(typeId: 6)
class DayTime extends Equatable {
  @HiveField(0)
  final int hour;
  @HiveField(1)
  final int minute;
  @HiveField(2)
  final String period;

  const DayTime({
    required this.hour,
    required this.minute,
    required this.period,
  });
  
  factory DayTime.fromTimeOfDay(TimeOfDay timeOfDay) => DayTime(
    hour: timeOfDay.hour, 
    minute: timeOfDay.minute, 
    period: timeOfDay.period.name,
  );

  DayTime copyWith({
    int? hour,
    int? minute,
    String? period,
  }) {
    return DayTime(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      period: period ?? this.period,
    );
  }

  @override
  String toString() => '$hour:$minute $period';

  @override
  List<Object> get props => [hour, minute, period];
}
