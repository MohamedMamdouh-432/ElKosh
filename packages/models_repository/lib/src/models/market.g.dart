// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MarketAdapter extends TypeAdapter<Market> {
  @override
  final int typeId = 3;

  @override
  Market read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Market(
      id: fields[0] as String,
      name: fields[1] as String,
      desc: fields[2] as String,
      hotline: fields[3] as String,
      imgUrl: fields[4] as String,
      active: fields[5] as bool,
      location: fields[8] as Location,
      beginTime: fields[6] as DayTime,
      endTime: fields[7] as DayTime,
    );
  }

  @override
  void write(BinaryWriter writer, Market obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.hotline)
      ..writeByte(4)
      ..write(obj.imgUrl)
      ..writeByte(5)
      ..write(obj.active)
      ..writeByte(6)
      ..write(obj.beginTime)
      ..writeByte(7)
      ..write(obj.endTime)
      ..writeByte(8)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
