import 'package:transcribe/config/config.dart';
import 'package:transcribe/models/models.dart';

class Boxes {
  static Box<User> getUser() => Hive.box<User>(Keys.keyBoxUser);

  static Box<UserAudioHistory> getAudio() =>
      Hive.box<UserAudioHistory>(Keys.keyBoxAudio);
}
