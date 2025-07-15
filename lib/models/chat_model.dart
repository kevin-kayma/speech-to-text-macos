class ChatHistoryModel {
  final int id;
  final String date;
  final List<ChatModel> chatModel;

  ChatHistoryModel(this.id, this.date, this.chatModel);
}

class ChatModel {
  final String msg;
  final int chatIndex;
  final bool isUser;

  ChatModel({required this.isUser, required this.msg, required this.chatIndex});

  @override
  String toString() {
    return 'ChatModel(msg: $msg, isUser: $isUser, chatIndex: $chatIndex)';
  }

  Map<String, dynamic> toJson() {
    return {'msg': msg, 'chatIndex': chatIndex, 'isUser': isUser};
  }
}
