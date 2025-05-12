// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paragraphs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParagraphsAdapter extends TypeAdapter<Paragraphs> {
  @override
  final typeId = 4;

  @override
  Paragraphs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Paragraphs(
      transcript: fields[0] as String,
      paragraphs: (fields[1] as List?)?.cast<Paragraph>(),
    );
  }

  @override
  void write(BinaryWriter writer, Paragraphs obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.transcript)
      ..writeByte(1)
      ..write(obj.paragraphs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParagraphsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
