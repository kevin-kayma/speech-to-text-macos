import 'package:hive_ce/hive.dart'; // Use `hive.dart` from hive_ce

part 'usermodel.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
//Queries used by user
  @HiveField(0)
  int intQueries = 0;

//Images Used by User
  @HiveField(1)
  int intImages = 0;

//Share Used by User
  @HiveField(2)
  int intShare = 0;

//Copy Used by User
  @HiveField(3)
  int intCopy = 0;

//Image Quantity
  @HiveField(4)
  int intImageQuantity = 0;

//Image Size
  @HiveField(5)
  String strImageSize = '256x256';

//Chat Review
  @HiveField(6)
  int? intChatReview = 0;

//Image Review
  @HiveField(7)
  int? intImageReview = 0;

//Image setting dismiss
  @HiveField(8)
  bool? isDismissImageSetting = false;

//Intro Loaded
  @HiveField(9)
  bool? isIntroLoaded = false;

//Audio Used by User
  @HiveField(10)
  int? intAudio = 0;

//Record Audio Used by User
  @HiveField(11)
  int? intRecordAudio = 0;

//Is Init Alert Dismiss
  @HiveField(12)
  String? strAlertID = "";
}
