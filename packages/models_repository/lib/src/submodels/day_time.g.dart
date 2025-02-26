// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayTimeAdapter extends TypeAdapter<DayTime> {
  @override
  final int typeId = 6;

  @override
  DayTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayTime(
      hour: fields[0] as int,
      minute: fields[1] as int,
      period: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DayTime obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.minute)
      ..writeByte(2)
      ..write(obj.period);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
