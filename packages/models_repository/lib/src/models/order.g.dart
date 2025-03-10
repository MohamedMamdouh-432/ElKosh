// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserOrderAdapter extends TypeAdapter<UserOrder> {
  @override
  final int typeId = 4;

  @override
  UserOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserOrder(
      id: fields[0] as String,
      code: fields[1] as int,
      total: fields[2] as double,
      items: (fields[8] as Map).cast<Product, int>(),
      ads: (fields[7] as Map).cast<Ad, int>(),
      userId: fields[3] as String,
      status: fields[4] as OrderStatus,
      createdAt: fields[5] as DateTime,
      location: fields[6] as Location,
    );
  }

  @override
  void write(BinaryWriter writer, UserOrder obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.ads)
      ..writeByte(8)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
