// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcribe/apis/network.dart';
import 'package:transcribe/config/constants.dart';
import 'package:transcribe/config/utils.dart';
import 'package:transcribe/models/chat_message.dart';
import 'package:transcribe/models/chat_model.dart';
import 'package:transcribe/providers/audio_provider.dart';

final chatbotProvider = ChangeNotifierProvider((ref) => ChatbotNotifier());

class ChatbotNotifier extends ChangeNotifier {
  List<ChatMessage> chatHistory = [];
  bool isLoading = false;
  bool isBotTyping = false;
  String? errorMessage;
  String typingMessageContent = '';
  String currentInputMessage = '';

  ChatbotNotifier();
  void updateInputMessage(String text) {
    currentInputMessage = text;
    notifyListeners();
  }

  void initMessageScreen(List<ChatMessage> chatBackup) {
    chatHistory.addAll(chatBackup);
    chatHistory = [
      ChatMessage(
        text:
            "👋 Hi there! I'm Transcriber AI.\n\nAsk me anything about your transcription — I can help summarize, find key points, or answer specific questions.",
        timestamp: DateTime.now(),
        sender: MessageSender.bot,
      ),
      ...chatBackup,
    ];
    notifyListeners();
  }

  Future<void> sendMessage(WidgetRef ref, BuildContext context, String message, String transcript, int audioId) async {
    if (message.trim().isEmpty || isLoading || isBotTyping) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final userMessage = ChatMessage(text: message.trim(), timestamp: DateTime.now(), sender: MessageSender.user);
    chatHistory.add(userMessage);

    typingMessageContent = '';
    isBotTyping = true;
    notifyListeners();

    try {
      List<ChatModel> chatModelsForApi = [];
      for (int i = 0; i < chatHistory.length; i++) {
        final msg = chatHistory[i];
        chatModelsForApi.add(ChatModel(isUser: msg.sender == MessageSender.user, msg: msg.text, chatIndex: i));
      }
      String prompt = buildQuestionPrompt(message, transcript, null);

      List<Map<String, dynamic>> contentList = [];
      contentList.add({"type": "text", "text": prompt});
      for (var chat in chatModelsForApi) {
        contentList.add({"type": "text", "text": chat.msg});
      }
      Map<String, dynamic> payload = {
        "model": chatGPTImageModel,
        "messages": [
          {"role": "user", "content": contentList},
        ],
        "max_tokens": 300,
      };

      List<ChatModel> apiResponse = await ApiService.sendMessageServerSide(payload: payload, context: context);

      String botFullResponseText = "Sorry, I couldn't get a clear response from the AI.";
      if (apiResponse.isNotEmpty) {
        botFullResponseText = apiResponse.last.msg;
      }

      for (int i = 0; i < botFullResponseText.length; i++) {
        typingMessageContent += botFullResponseText[i];
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 2));
      }
      // Session.chatCount = Session.chatCount + 1;
      final botMessage = ChatMessage(text: botFullResponseText, timestamp: DateTime.now(), sender: MessageSender.bot);
      chatHistory.add(botMessage);

      await ref.read(audioListProvider.notifier).updateMessageList(audioId, chatHistory.sublist(1, chatHistory.length));
      Utils.reviewDialog(context);
    } catch (e) {
      errorMessage = "Failed to get response : $e";
    } finally {
      isLoading = false;
      isBotTyping = false;
      typingMessageContent = '';
      notifyListeners();
    }
  }

  String buildQuestionPrompt(String question, String? transcription, String? context) {
    StringBuffer prompt = StringBuffer();

    prompt.writeln("Please answer the following question based on the provided information:");
    prompt.writeln("\n**Question:** $question");

    if (transcription != null && transcription.trim().isNotEmpty) {
      prompt.writeln("\n**Transcription Content:**");
      prompt.writeln(transcription.trim());
    }

    if (context != null && context.trim().isNotEmpty) {
      prompt.writeln("\n**Additional Context:**");
      prompt.writeln(context.trim());
    }

    prompt.writeln("\n**Instructions:**");
    prompt.writeln("- Provide a clear, accurate answer based on the transcription");
    prompt.writeln("- If the information is not available in the transcription, mention that");
    prompt.writeln("- Be concise but comprehensive");
    prompt.writeln("- Use specific details from the transcription when relevant");

    return prompt.toString();
  }
}
