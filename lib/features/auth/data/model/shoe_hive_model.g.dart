// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shoe_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoeHiveModelAdapter extends TypeAdapter<ShoeHiveModel> {
  @override
  final int typeId = 0;

  @override
  ShoeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoeHiveModel(
      shoeId: fields[0] as String,
      name: fields[1] as String,
      brand: fields[2] as String,
      price: fields[3] as double,
      category: fields[4] as String,
      sizes: (fields[5] as List).cast<String>(),
      imageUrl: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShoeHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.shoeId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.sizes)
      ..writeByte(6)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
