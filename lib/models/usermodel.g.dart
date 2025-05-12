// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usermodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    reader.readByte();
    return User();
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.intQueries)
      ..writeByte(1)
      ..write(obj.intImages)
      ..writeByte(2)
      ..write(obj.intShare)
      ..writeByte(3)
      ..write(obj.intCopy)
      ..writeByte(4)
      ..write(obj.intImageQuantity)
      ..writeByte(5)
      ..write(obj.strImageSize)
      ..writeByte(6)
      ..write(obj.intChatReview)
      ..writeByte(7)
      ..write(obj.intImageReview)
      ..writeByte(8)
      ..write(obj.isDismissImageSetting)
      ..writeByte(9)
      ..write(obj.isIntroLoaded)
      ..writeByte(10)
      ..write(obj.intAudio)
      ..writeByte(11)
      ..write(obj.intRecordAudio)
      ..writeByte(12)
      ..write(obj.strAlertID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
