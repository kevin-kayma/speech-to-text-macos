// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listaudiomodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAudioHistoryAdapter extends TypeAdapter<UserAudioHistory> {
  @override
  final int typeId = 1;

  @override
  UserAudioHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAudioHistory()
      ..audioList = (fields[0] as List).cast<AudioModel>();
  }

  @override
  void write(BinaryWriter writer, UserAudioHistory obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.audioList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAudioHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
