// Use `hive.dart` from hive_ce
import 'package:transcribe/models/audiomodel.dart';

import 'package:hive/hive.dart';

part 'listaudiomodel.g.dart';

@HiveType(typeId: 1)
class UserAudioHistory extends HiveObject {
  @HiveField(0)
  List<AudioModel> audioList = [];
}
