import 'package:hive_ce_flutter/hive_flutter.dart';

import 'responsemodel.dart';

part 'audiomodel.g.dart';

@HiveType(typeId: 2)
class AudioModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String filename;

  @HiveField(2)
  final String filePath;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final Responsemodel? responseModel;

  AudioModel({
    required this.id,
    required this.filename,
    required this.filePath,
    required this.date,
    required this.responseModel,
  });
}
