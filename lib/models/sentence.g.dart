// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SentenceAdapter extends TypeAdapter<Sentence> {
  @override
  final int typeId = 6;

  @override
  Sentence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sentence(
      text: fields[0] as String,
      confidence: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Sentence obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.confidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SentenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
