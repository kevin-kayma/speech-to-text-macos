// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responsemodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResponsemodelAdapter extends TypeAdapter<Responsemodel> {
  @override
  final int typeId = 3;

  @override
  Responsemodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Responsemodel(
      paragraphs: fields[0] as Paragraphs,
    );
  }

  @override
  void write(BinaryWriter writer, Responsemodel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.paragraphs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsemodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
