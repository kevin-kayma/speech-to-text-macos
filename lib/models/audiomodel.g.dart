// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audiomodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioModelAdapter extends TypeAdapter<AudioModel> {
  @override
  final int typeId = 2;

  @override
  AudioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioModel(
      id: fields[0] as int,
      filename: fields[1] as String,
      filePath: fields[2] as String,
      date: fields[3] as String,
      responseModel: fields[4] as Responsemodel?,
      summary: fields[5] as String?,
      chatList: (fields[6] as List?)?.cast<ChatMessage>(),
    );
  }

  @override
  void write(BinaryWriter writer, AudioModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.filename)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.responseModel)
      ..writeByte(5)
      ..write(obj.summary)
      ..writeByte(6)
      ..write(obj.chatList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
