import 'package:hive/hive.dart';
import 'package:transcribe/models/chat_message.dart';
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

  @HiveField(5)
  String? summary;

  @HiveField(6)
  List<ChatMessage>? chatList;

  AudioModel({
    required this.id,
    required this.filename,
    required this.filePath,
    required this.date,
    required this.responseModel,
    this.summary,
    this.chatList,
  });

  AudioModel copyWith({
    int? id,
    String? filename,
    String? filePath,
    String? date,
    Responsemodel? responseModel,
    String? summary,
    List<ChatMessage>? chatList,
  }) {
    return AudioModel(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      filePath: filePath ?? this.filePath,
      date: date ?? this.date,
      responseModel: responseModel ?? this.responseModel,
      summary: summary ?? this.summary,
      chatList: chatList ?? this.chatList,
    );
  }

  @override
  String toString() {
    return 'AudioModel(id: $id, filename: $filename, filePath: $filePath, date: $date, responseModel: $responseModel, summary: $summary)';
  }
}
