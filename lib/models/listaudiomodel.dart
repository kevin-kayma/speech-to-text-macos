import 'package:hive_flutter/adapters.dart';
import 'package:transcribe/models/audiomodel.dart';

part 'listaudiomodel.g.dart';

@HiveType(typeId: 1)
class UserAudioHistory extends HiveObject {
  @HiveField(0)
  List<AudioModel> audioList = [];
}
