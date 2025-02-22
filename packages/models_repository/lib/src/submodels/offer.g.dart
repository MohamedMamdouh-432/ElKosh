// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfferAdapter extends TypeAdapter<Offer> {
  @override
  final int typeId = 3;

  @override
  Offer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Offer(
      product: fields[2] as Product,
      quantity: fields[0] as int,
      price: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Offer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.product);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
