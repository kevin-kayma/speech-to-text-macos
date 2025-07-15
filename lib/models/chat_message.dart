import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 13) // Ensure unique typeId across all Hive models
enum MessageSender {
  @HiveField(0)
  user,
  @HiveField(1)
  bot,
}

@HiveType(typeId: 14) // Ensure unique typeId across all Hive models
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String text;
  @HiveField(1)
  final DateTime timestamp;
  @HiveField(2)
  final MessageSender sender;

  ChatMessage({required this.text, required this.timestamp, required this.sender});

  @override
  String toString() {
    return 'ChatMessage(text: "$text", timestamp: $timestamp, sender: $sender)';
  }
}
