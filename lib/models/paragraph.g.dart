// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paragraph.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParagraphAdapter extends TypeAdapter<Paragraph> {
  @override
  final int typeId = 5;

  @override
  Paragraph read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Paragraph(
      sentences: (fields[0] as List).cast<Sentence>(),
      numWords: fields[1] as int,
      start: fields[2] as double,
      end: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Paragraph obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sentences)
      ..writeByte(1)
      ..write(obj.numWords)
      ..writeByte(2)
      ..write(obj.start)
      ..writeByte(3)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParagraphAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
