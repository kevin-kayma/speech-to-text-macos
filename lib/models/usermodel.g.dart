// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usermodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..intQueries = fields[0] as int
      ..intImages = fields[1] as int
      ..intShare = fields[2] as int
      ..intCopy = fields[3] as int
      ..intImageQuantity = fields[4] as int
      ..strImageSize = fields[5] as String
      ..intChatReview = fields[6] as int?
      ..intImageReview = fields[7] as int?
      ..isDismissImageSetting = fields[8] as bool?
      ..isIntroLoaded = fields[9] as bool?
      ..intAudio = fields[10] as int?
      ..intRecordAudio = fields[11] as int?
      ..strAlertID = fields[12] as String?;
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
