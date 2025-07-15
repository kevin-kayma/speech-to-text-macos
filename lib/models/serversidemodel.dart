class ServerChatResponseModel {
  final List<ServerChatChoice> choices;

  ServerChatResponseModel({
    required this.choices,
  });

  factory ServerChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ServerChatResponseModel(
      choices: List<ServerChatChoice>.from(
        (json['choices'] as List).map(
          (choice) => ServerChatChoice.fromJson(choice),
        ),
      ),
    );
  }
}

class ServerChatChoice {
  final int index;
  final ServerChatMessage message;
  final String finishReason;

  ServerChatChoice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  factory ServerChatChoice.fromJson(Map<String, dynamic> json) {
    return ServerChatChoice(
      index: json['index'],
      message: ServerChatMessage.fromJson(json['message']),
      finishReason: json['finish_reason'],
    );
  }
}

class ServerChatMessage {
  final String role;
  final String content;

  ServerChatMessage({
    required this.role,
    required this.content,
  });

  factory ServerChatMessage.fromJson(Map<String, dynamic> json) {
    return ServerChatMessage(
      role: json['role'],
      content: json['content'],
    );
  }
}
