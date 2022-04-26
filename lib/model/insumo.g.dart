// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insumo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsumoAdapter extends TypeAdapter<Insumo> {
  @override
  final int typeId = 0;

  @override
  Insumo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Insumo(
      product: fields[0] as String?,
      value: fields[1] as String?,
      mesureType: fields[2] as String?,
      inputDate: fields[3] as String?,
      observation: fields[4] as String?,
      status: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Insumo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.mesureType)
      ..writeByte(3)
      ..write(obj.inputDate)
      ..writeByte(4)
      ..write(obj.observation)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsumoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
