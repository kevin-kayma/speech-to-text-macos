// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listaudiomodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAudioHistoryAdapter extends TypeAdapter<UserAudioHistory> {
  @override
  final typeId = 1;

  @override
  UserAudioHistory read(BinaryReader reader) {
    reader.readByte();
    return UserAudioHistory();
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
